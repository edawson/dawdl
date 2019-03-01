task samtools_sort{
    File inputBAM
    Int? threads
    Int? memoryPerThread
    Int? diskGB

    String outbase = basename(inputBAM, ".bam")
    
    Int selectedMem = select_first([memoryPerThread, 1])

    Int totalMem = 4 * selectedMem

    command {
        samtools sort -m ${memoryPerThread}G  -o ${outbase}.sorted.bam -@ ${threads} ${inputBAM} && \
        samtools index -t ${threads} ${outbase}.sorted.bam
    }


    runtime{
        docker : "erictdawson/samtools"
        cpu : "${threads}"
        memory : totalMem + 1.7 + " GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File sortedBAM = "${outbase}.sorted.bam"
        File sortedBAMIndex = "${outbase}.sorted.bam.bai"
    }
}
