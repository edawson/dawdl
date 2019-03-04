task VariantBamExtractTask{
    File bam
    File bamIndex
    File rulesJSON
    String label
    Int threads
    Int diskGB

    String outbase = basename(bam, ".bam") + "." + label + ".bam"

    command {
        variant ${bam} -r ${rulesJSON} -t ${threads} > ${outbase}.bam
    }


    runtime {
        docker : "erictdawson/variantbam"
        bootDiskSizeGb: 20
        cpu : "${threads}"
        memory : "3.2 GB"
        preemptible : 1
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File variantbam_extracted_bam = "${outbase}.bam"
    }
}

workflow dummyflow{

}

