task TelSeqTasks{
    File inputBAM
    File inputBAI
    Int readLength
    Int diskGB

    String? outbase = basename(inputBAM, ".bam") 

    command {
        telseq -r ${readLength} -u ${inputBAM} > ${outbase}.telseq.txt
    }

    runtime{
        docker : "erictdawson/telseq"
        cpu : 1
        memory : "6GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 3
    }

    output{
        File telseq_output = "${outbase}.telseq.txt"
    }


}

workflow dummy_flow{

}
