task variantbam_extract_task{
    File bam
    File bamIndex
    File rulesJSON
    String label
    String? tag
    Int threads
    Int diskGB

    String outbase = basename(bam, ".bam")

    String outfile = outbase + "."  + label + "." + select_first([tag + ".", ""]) + ".bam"



    command {
        variantbam ${bam} -r ${rulesJSON} -t ${threads} > ${outbase}.${label}.bam
    }


    runtime {
        docker : "erictdawson/variantbam"
        cpus : "${threads}"
        memory : "3.2 GB"
        preemptible_tries : 1
    }

    output{
        File variantbam_extracted_bam = "${outfile}"
    }
}

