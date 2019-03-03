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
