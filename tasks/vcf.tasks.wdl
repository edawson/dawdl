task VCFIndexTask{
    File inputVCF
    Int? memory
    Int? threads
    Int diskGB

    Int selectedMem = select_first([memory, 0])

    String infileBase = basename(inputVCF)

    
    command {
       bgzip -c ${"-@ " + threads} ${inputVCF} > ${infileBase}.gz && \
       tabix ${infileBase}.gz
    }


    runtime{
        docker : "erictdawson/samtools"
        cpu : "${threads}"
        memory : selectedMem + 1.5 + " GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 2
    }

    output{
        File indexedVCFgz = "${infileBase}.gz"
        File indexedVCFtbi = "${infileBase}.gz.tbi"
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

workflow dummyFlow{

}
