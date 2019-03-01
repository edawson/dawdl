task dupholdTASK{
    File inputBAM
    File inputBAI

    File inputVCFGZ
    File inputVCFTBI

    File FASTA
    File FAI

    Int? threads
    Int? diskGB

    String obase = basename(inputVCFGZ, ".vcf.gz")

    command{
        duphold -v ${inputVCFGZ} \
            -b ${inputBAM} -f ${FASTA} \
            -o ${obase}.dupholded.vcf -t 4 && 
            bgzip ${obase}.dupholded.vcf &&
            tabix ${obase}.dupholded.vcf.gz
    }

    runtime{
        docker : "erictdawson/duphold"
        cpu : "${threads}"
        memory : "16GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output{
        File dupholdAnnotatedVCFGZ = "${obase}.dupholded.vcf.gz"
        File dupholdAnnotatedVCFTBI = "${obase}.dupholded.vcf.gz.tbi"
    }

}
