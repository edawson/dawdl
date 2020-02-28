task GenerateSBSMatrix{
    File maf
    Int diskGB
    String? outbase = "results"

    command{
        python3 /usr/bin/generate_matrix.py -m ${maf} -d sigprof_input  && \
        mv sigprof_input/output/SBS/PROJECT.SBS96.all ${outbase}.SBS96.all && \
        tar czf ${outbase}.sigpromatgen.tgz sigprof_input/
    }

    runtime{
        docker : "erictdawson/sigprofiler-py-cpu:latest"
        cpu : "2"
        memory : "8 GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File countsMatrix = "${outbase}.SBS96.all"
        File resultsTarball = "${outbase}.sigpromatgen.tgz"
    }

}

task ExtractSignatures{
    File countsMatrix
    Int diskGB
    Int? threads=16
    Int? memory = ceil(2 * threads)
    Int? startSigs = 1
    Int? endSigs = 8
    Int? iters = 1000
    

    command{
        python3 /usr/bin/run_sigprofiler.py -s ${startSigs} \
            -e ${endSigs} \
            -i ${iters} \
            -t ${countsMatrix} \
            -c ${threads} \
            -d extractor_results && \
            tar czf extractor_results.tgz extractor_results/
    }

    runtime{
        docker : "erictdawson/sigprofiler-py-cpu:latest"
        cpu : "${threads}"
        memory : "${memory}GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File resultsTarball = "extractor_results.tgz"
    }
}


workflow SigprofilerSBS{
    File maf
    Int diskGB = ceil((size(maf, "GB") * 2))

    call GenerateSBSMatrix{
        input:
            maf=maf,
            diskGB=diskGB
    }
    
    call ExtractSignatures{
        input:
            countsMatrix=GenerateSBSMatrix.countsMatrix
    }

}
