task TELSEQ_TASK{
    File inputBam
    File inputBai
    Int readLength
    Int diskGB
    String telseqOutName = basename(inputBam, ".bam") + ".telseq.txt"
    
    command <<<
        telseq -r ${readLength} -u ${inputBam} > ${telseqOutName}
    >>>

    runtime{
        docker : "erictdawson/svdocker:latest"
        cpu : 1
        memory : "3.7 GB"
        bootDiskSizeGb: 12
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 2
    }

    output{
        File telseq_output = "${telseqOutName}"
    }
}

workflow TELSEQ{
    File inputBam
    File inputBai
    Int readLength

    Int diskGB = ceil(size(inputBam, "GB") + size(inputBai, "GB") + 20)

    call TELSEQ_TASK{
        input:
            inputBam=inputBam,
            inputBai=inputBai,
            readLength=readLength,
            diskGB=diskGB
    }

    output{
        File telseq_results = TELSEQ_TASK.telseq_output
    }

}
