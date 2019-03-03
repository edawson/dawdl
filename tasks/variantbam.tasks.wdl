task VariantBamExtract{
    File bam
    File bamIndex
    File rulesJSON
    String label
    Int threads
    Int diskGB

    String outbase = basename(bam, ".bam")
    String outfile = outbase + "."  + label + "."  + "bam"

    command {
        variantbam ${bam} -r ${rulesJSON} -t ${threads} > ${outfile}.bam
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

