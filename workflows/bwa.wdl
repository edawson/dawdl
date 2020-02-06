task BWAIndexTask{
    File fastaFile

    command{
        bwa index ${fastaFile}
    }

    runtime{
        docker : "erictdawson/bwa"
        cpu : 1
        memory : "20GB"
    }

    output{

    }

}

task BWAMEMTask{

}

workflow BWAWorkflow{

}
