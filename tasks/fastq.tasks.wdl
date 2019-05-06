task FastqInterleaveGZTask{
    File firstFQ
    File secondFQ
    Int threads
    Int diskGB

    String outbase = basename(basename(basename(basename(basename(basename(firstFQ, ".gz"), ".fq"), ".fastq"), ".fa"),"fasta"), "_1")

    command{
       interleave-fastq ${firstFQ} ${secondFQ} | pigz -c -p 4 > ${outbase}.interleaved.gz 
    }

    runtime{
        docker : "erictdawson/base"
        cpu : 4
        memory : "3.7 GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output {
        File interleaved_fastq = "${outbase}.interleaved.fq.gz"
    }
}

task FastqSplitTask{
    File firstFQ
    File secondFQ

    Int linesPerFile
    Int diskGB

    String outbase = basename(basename(basename(basename(basename(firstFQ, ".gz"), ".fq"), ".fastq"), ".fa"),"fasta")


    command {
        pigz -c -d -p4 | grep -v "^$" | split -d -a 5  -l ${linesPerFile} - ${outbase}
    }
    
    runtime{
        docker : "erictdawson/base"
        cpu : 4
        memory : "3.7 GB"
        disks : "local-disk " + diskGB + " HDD"
    }

    output {
        Array[File] fastq_splits = glob("*split*.gz")
    }
}
