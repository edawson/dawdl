task CalculateSensitivityTask{
    Int depth
    Float purity

    command {
        python calculate_driver_sensitivity.py ${depth} ${purity}
    }

    runtime{
        docker : "erictdawson/python"
        cpu : 1
        memory : "0.75 GB"
        preemptible : 1
        disks : "local-disk 10 HDD"
    }

    output{
        String sensitivity = read_string(stdout())
    }
}

workflow CalculateDriverSensitivity{
    Int depth
    Float purity

    call CalculateSensitivityTask{
        input:
            depth=depth,
            purity=purity
    }
}
