task shardFASTQTask{
    File firstFQ

    Int linesPerFile
    Int diskGB

    String outbase = basename(basename(basename(basename(basename(firstFQ, ".gz"), ".fq"), ".fastq"), ".fa"),"fasta")


    command {
        pigz -c -d -p4 ${firstFQ} | grep -v "^$" | split -d -a 5  -l ${linesPerFile} - ${outbase} && \
        for i in `ls | grep "${outbase}" | grep "split"`
        do
            pigz -p 4 -c $i > $i.gz
        done
    }

    runtime{
        docker : "erictdawson/base"
        cpu : 4
        memory : "3.7 GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 4
    }

    output {
        Array[File] fastq_splits = glob("*split*.gz")
    }
}

task shardFASTATask{
    File firstFA

    Int linesPerFile
    Int diskGB

    String outbase = basename(basename(basename(firstFQ, ".gz"), ".fa"),"fasta")


    command {
        pigz -c -d -p4 ${firstFA}| grep -v "^$" | split -d -a 5  -l ${linesPerFile} - ${outbase}
        for i in `ls | grep "${outbase}" | grep "split"`
        do
            pigz -p 4 -c $i > $i.gz
        done
    }

    runtime{
        docker : "erictdawson/base"
        cpu : 4
        memory : "3.7 GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 4
    }

    output {
        Array[File] fastq_splits = glob("${outbase}*split*.gz")
    }
}

task sliceVCFByChromTask{
    File inputVCF
    String chrom
    Int diskGB

    String outbase = basename(basename(inputVCF, ".gz"), ".vcf")

    command{
        tabix -f ${inputVCF} && tabix -h ${inputVCF} ${chrom} > ${outbase}.${chrom}.vcf
    }

    runtime{
        docker : "erictdawson/samtools"
        cpu : 1
        memory : "1GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 4
    }

    output{
        File chromVCF = "${outbase}.${chrom}.vcf"
    }
}

task shardVCFByChromTask{
    File inputVCFGZ
    File inputTBI
    File chromFile
    Int diskGB

    String outbase = basename(basename(inputVCFGZ, ".gz"), ".vcf")

    command{

    }

    runtime{

    }

    output{

    }
}

task ShardVCFByBedTask{

}

task shardBEDTask{
    File inputBED
    Int splitSize
    Int diskGB
}

task shardBEDByCoverageTask{

}

task shardBAMByReadCountTask{
    File inputBAM
    Int readCount
    Int diskGB
}

task shardBAMByChromosomeTask{

}

task shardBAMByBEDTask{

}

task shardTFATask{
    File tfaFile
    Int linesPerFile
    Int diskGB

    String outbase = basename(basename(tfaFile, ".gz"), ".tfa") + ".split."

    command{
        split -l ${linesPerFile} -d -a 5 ${tfaFile} ${outbase}
    }

    runtime{
        docker : "erictdawson/tfatools"
        cpu : 1
        memory : "1 GB"
        disks : "local-disk " + diskGB + " HDD"
    }
    output{
        Array[File] tfaShards = glob("${outbase}")
    }
}

workflow dummy_flow{

}
