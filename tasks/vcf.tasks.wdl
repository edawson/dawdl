task VCFIndexTask{
    File inputVCF
    Int? threads
    Int? memory
    Int? diskGB

    Int selectedMem = select_first([memory, 0])
    String outbase = basename(inputVCF, ".vcf")

    
    command {
       bgzip ${"-@=" + threads} ${inputVCF} && \
       tabix ${outbase}.vcf.gz
    }


    runtime{
        docker : "erictdawson/samtools"
        cpu : "${threads}"
        memory : selectedMem + 1.5 + " GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File indexedVCFgz = "${outbase}.vcf.gz"
        File indexVCFtbi = "${outbase}.vcf.gz"
    }
}

task VCFSliceTask{
    File inputVCF
    File inputTBI
    File restrictBED
    Int? memory
    Int? threads
    Int diskGB

    Int selectedMem = select_first([memory, 0])
    String outbase = basename(inputVCF, ".vcf")
    String restrictBase = basename(basename(restrictBED, ".bed"), ".gz")

    command{
        bedtools intersect -sorted -header -wa -a ${inputVCF} -b ${restrictBED} > ${outbase}.${restrictBase}.vcf
    }

    runtime{
        docker : "erictdawson/bedtools"
        cpu : "${threads}"
        memory : selectedMem + 1.5 + " GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File slicedVCF = "${outbase}.${restrictBase}.vcf"
    }
}
