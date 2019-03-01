task bam-index{
    File inputBAM
    Int? threads
    Int? memory
    Int? diskGB

    
    command {

    }


    runtime{
        docker : "erictdawson/sambamba"
        cpu : "${threads}"
        memory : ${memory} + 3.4 + " GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output{


    }
}
