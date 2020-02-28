task telomerecat_bam2telbam_TASK{
    File sampleBAM
    String sampleNAME
    String outname = basename(sampleBAM, ".bam") + "_telbam.bam"
    Int diskGB
    Int? threads = 4
   
    runtime{
        docker : "erictdawson/telomerecat"
        memory : "7GB"
        cpu : "${threads}"
        disks : "local-disk "+ diskGB + " HDD"
        preemptible : 3
    }

    command <<<
        telomerecat bam2telbam -p ${threads}  ${sampleBAM}
    >>>

    output{
        File telomerecat_telbam = "${outname}"
    }
}

task telomerecat_telbam2length_TASK{
    File telbam
    String sampleNAME
    Int diskGB
    Int? threads = 4

    runtime{
        docker : "erictdawson/svdocker:latest"
        memory : "7GB"
        cpu : "${threads}"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 3
    }

    command <<<
        telomerecat telbam2length -p 8 ${telbam}
    >>>

    output{
        File telomerecat_csv = glob("*.csv")[0]
    }
}

workflow TelomerecatWORKFLOW{
    File inputBAM
    String sampleNAME

    Int diskGB = ceil(size(inputBAM, "GB") + 100)
    Int? threads = 4

    call telomerecat_bam2telbam_TASK{
        input:
            sampleNAME=sampleNAME,
            sampleBAM=inputBAM,
            diskGB=diskGB
    }

    call telomerecat_telbam2length_TASK{
        input:
            telbam=telomerecat_bam2telbam_TASK.telomerecat_telbam,
            sampleNAME=sampleNAME,
            diskGB=diskGB
    }
}
