task telomerecatBamToTelbamTask{
    File inputBAM
    String outbase
    Int threads
    Int diskGB

    String outname = basename(inputBAM, ".bam") + "_telbam.bam"
    Int mem = ceil(threads * 3.5)


    command{
        telomerecat bam2telbam -p ${threads} ${inputBAM}
    }

    runtime{
        docker : "erictdawson/telomerecat"
        memory : mem + "GB"
        cpu : "${threads}"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 4
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
        memory : "6 GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 4
    }

    output{
        File telomerecat_csv = glob("*.csv")[0]
    }
}

workflow dummy_flow{

}
