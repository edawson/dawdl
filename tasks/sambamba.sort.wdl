task bam-sort{
    File inputBAM
    Int? threads
    Int? memory
    Int? diskGB

    String outbase = basename(inputBAM, ".bam")

    command {
        sambamba sort -m ${memory}G  -o ${outbase}.sorted.bam -t ${threads} ${inputBAM}
    }


    runtime{
        docker : "erictdawson/sambamba"
        cpu : "${threads}"
        memory : memory + 3.4 + " GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File sortedBAM = "${outbase}.sorted.bam"
        File sortedBAMIndex = "${outbase}.sorted.bam.bai"
    }
}
