## Run bam-matcher, a python
## pipeline for verifying if two
## BAM files are from the same sample.

task BamMatcherTask{
    File firstBAM
    File firstBAI
    File secondBAM
    File secondBAI

    File reference

    Int diskGB

    String output_name = basename(firstBAM, ".bam") + "." + basename(secondBAM, ".bam") + ".bam-matcher-report.txt"
    
    command<<<
        bam-matcher-wrapper.sh ${firstBAM} ${secondBAM} ${reference} `pwd`
    >>>

    runtime{
        docker : "erictdawson/bam-matcher"
        cpu : 1
        disks : "local-disk " + diskGB + " HDD"
        memory : "8GB"
        preemptible : 2
    }

    output{
        File bam_matcher_report = "${output_name}"
    }
    
}

workflow BamMatcher{
    File firstBAM
    File firstBAI
    File secondBAM
    File secondBAI
    File reference

    Int diskGB = ceil(size(firstBAM, "GB") + size(secondBAM, "GB") + size(firstBAI, "GB") + size(secondBAI, "GB") + size(reference, "GB")) + 20

    call BamMatcherTask{
        input:
            firstBAM=firstBAM,
            firstBAI=firstBAI,
            secondBAM=secondBAM,
            secondBAI=secondBAI,
            reference=reference,
            diskGB=diskGB

    }

}