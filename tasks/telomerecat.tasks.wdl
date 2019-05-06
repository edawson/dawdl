task telomerecatBamToTelbamTask{
    File inputBAM
    String outbase
    Int threads
    Int diskGB

    String outname = basename(inputBAM, ".bam") + "_telbam.bam"


    command{
        telomerecat bam2telbam -p ${threads} ${inputBAM}
    }

    runtime{
        docker : "erictdawson/telomerecat"
        memory : "8 GB"
        cpu : "${threads}"
        disks : "local-disk " + diskGB + " HDD"
    }
    output{
        File telBAM = "${outname}"
    }

}

task telomerecatTelbamToLengthTask{
    File telBAM
    String outbase
    Int threads
    Int diskGB
    
    command{
       telomerecat telbam2length -p ${threads} ${telBAM} 
    }

    runtime{
        docker : "erictdawson/telomerecat"
        cpu : "${threads}"
        memory : "8 GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File telomerecat_csv = glob("*.csv")[0]
    }
}

workflow dummy_flow{

}
