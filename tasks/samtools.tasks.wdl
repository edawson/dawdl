task SamtoolsSort{
    File inputBAM
    Int? threads
    Int? memoryPerThread
    Int? diskGB
    Int? preemptible_attempts

    String outbase = basename(inputBAM, ".bam")
    
    Int selectedMem = select_first([memoryPerThread, 1])

    Int totalMem = threads * selectedMem

    command {
        samtools sort -m ${memoryPerThread}G  -o ${outbase}.sorted.bam -@ ${threads} ${inputBAM} && \
        samtools index -t ${threads} ${outbase}.sorted.bam
    }


    runtime{
        docker : "erictdawson/samtools"
        cpu : "${threads}"
        memory : totalMem + 1.7 + " GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : preemptible_attempts
    }

    output{
        File sortedBAM = "${outbase}.sorted.bam"
        File sortedBAMIndex = "${outbase}.sorted.bam.bai"
    }
}

task SamtoolsIndex{
    File inputBAM
    Int diskGB

    command{
        samtools index ${inputBAM}
    }

    runtime{
        docker : "erictdawson/samtools"
        cpu : 1
        memory : "1.6 GB"
        disks : "local-disk " + diskGB + " GB"
    }

    output{
        File bamIndex = "${inputBAM}.bai"
    }
}

task SamtoolsMerge{
    Array[File] bams
    Array[File] bais
    String outbase
    Int diskGB
    Int? threads
    Int? memory

    memory = select_first([memory, 1.5])

    command{
        samtools merge -b ${write_lines(bams)} > ${outbase}.bam
    }
    
    runtime{
        docker : "erictdawson/samtools"
        cpu : 1
        disks : "local-disk " + diskGB + " GB"
        memory : memory + " GB"
        preemptible : 0
    }
}