task VCFIndexTask{
    File inputVCF
    Int? memory
    Int? threads
    Int diskGB

    Int selectedMem = select_first([memory, 0])

    String infileBase = basename(basename(inputVCF, ".gz"), ".vcf")

    
    command {
       bgzip -c ${"-@ " + threads} ${inputVCF} > ${infileBase}.vcf.gz && \
       tabix ${infileBase}.vcf.gz
    }


    runtime{
        docker : "erictdawson/samtools"
        cpu : "${threads}"
        memory : selectedMem + 1.5 + " GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 2
    }

    output{
        File indexedVCFgz = "${infileBase}.vcf.gz"
        File indexedVCFtbi = "${infileBase}.vcf.gz.tbi"
    }
}

task VCFSortTask{
    File inputVCF

    Int diskGB

    String outbase = basename(basename(inputVCF, ".gz"), ".vcf")

    command{
        vcfsort ${inputVCF} > ${outbase}.sorted.vcf
    }

    runtime{
        docker : "erictdawson/samtools"
        cpu : 1
        memory : "14 GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 2
    }

    output{
        File sortedVCF = "${outbase}.sorted.vcf"
    }
}

task VCFSliceTask{
    File inputVCF
    File inputTBI
    File restrictBED
    Int? memory
    Int diskGB

    Int selectedMem = select_first([memory, 0])
    String outbase = basename(inputVCF, ".vcf")
    String restrictBase = basename(basename(restrictBED, ".bed"), ".gz")

    command{
        bedtools intersect -sorted -header -wa -a ${inputVCF} -b ${restrictBED} > ${outbase}.${restrictBase}.vcf
    }

    runtime{
        docker : "erictdawson/bedtools"
        cpu : 1
        memory : selectedMem + 1.5 + " GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 2
    }

    output{
        File slicedVCF = "${outbase}.${restrictBase}.vcf"
    }
}

task VCFSliceFastWithDiskTask{
    File inputVCF
    File? inputTBI
    File restrictBED
    Int diskGB

    String outbase = basename(inputVCF, ".vcf")
    String restrictbase = basename(basename(restrictBED, ".bed"), ".gz")

    command{
        bedtools intersect -wa -sorted -header -nonamecheck \
        -a <(pigz -d -c -p 4 ${inputVCF} | vcfsort-streaming-parallel ) \
        -b ${restrictBED} \
        > ${outbase}.${restrictbase}.vcf && \
        bgzip -@12 ${outbase}.${restrictbase}.vcf && \
        tabix -f ${outbase}.${restrictbase}.vcf.gz
        }

    runtime{
        docker : "erictdawson/bedtools"
        cpu : 12
        memory : "3.7 GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 1
    }

    output{
        File slicedVCF = "${outbase}.${restrictbase}.vcf.gz"
        File slicedVCFtbi = "${outbase}.${restrictbase}.vcf.gz.tbi"
    }
}

workflow dummyFlow{

}


