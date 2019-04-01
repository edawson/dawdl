task MosdepthQuantizeTask{
    File inputBam
    File inputBai
    Int? threads = 2
    Int diskGB
    
    Int lowThreshold
    Int highThreshold
    

    String pref = basename(inputBam, ".bam")


    command {
    export MOSDEPTH_Q0=NO_COVERAGE &&
    export MOSDEPTH_Q1=LOW_COVERAGE &&
    export MOSDEPTH_Q2=CALLABLE   &&
    export MOSDEPTH_Q3=HIGH_COVERAGE &&
        mosdepth -t ${threads} \
        --quantize 0:1:${lowThreshold}:${highThreshold} \
        ${pref} ${inputBam}
    }

    runtime{
        docker : "erictdawson/svdocker:latest"
        cpu : "${threads}"
        memory : "3.5GB"
        preemptible : 2
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File mosdepth_quantized_depth = pref + ".quantized.bed.gz"
        File mosdepth_per_base_depth = pref + ".per-base.bed.gz"
        File mosdepth_global_depth_distribution = pref + ".mosdepth.global.dist.txt"
    }
}

