## Provides various ways to cut a bam file

# Restrict a single BAM file to the regions provided 
# in a BED file.
# Consumes a single BAM file, produces a single BAM file.
task RestrictBamTask{
    File inputBAM
    File inputBAI
    File restrictBED
    Int? threads
    Int? memory
    Int? diskGB

    Int selectedMem = select_first([memory, 0])
    String outbase = basename(inputBAM, ".bam") + "." + basename(restrictBED, ".bed")

    
    command {
       samtools view -L ${restrictBED} -@ ${threads} -b ${inputBAM} > ${outbase}.restricted.bam && \
       samtools index ${outbase}.restricted.bam
    }


    runtime{
        docker : "erictdawson/samtools"
        cpu : "${threads}"
        memory : selectedMem + 1.5 + " GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 3
    }

    output{
        File restrictedBAM = "${outbase}.restricted.bam"
        File restrictedBAMIndex = "${outbase}.restricted.bam.bai"
    }
}

# Shard a BAM file into smaller BAMs
# based on a set of regions defined in a BED file.
# bedtools_to_samtools_region is from github.com/edawson/helpy
# launcher.py is from github.com/edawson/LaunChair
# N.B.: BAM files returned are not sorted or indexed.
task ShardBamTask{
    File inputBAM
    File inputBAI
    File shardBED
    Int? slop
    Int? threads
    Int? memory
    Int? compressionThreads
    Int? diskGB

    Int selectedMem = select_first([memory, 0])
    Int usedSlop = select_first([slop, 0])
    Int usedCompressionThreads = select_first([compressionThreads, 1])
    Int usedThreads = select_first([threads, 1])
    String outbase = basename(inputBAM, ".bam") + "." + basename(shardBED, ".bed")

    String dollar = "$"
    
    command <<<
       for i in `wc -l ${shardBED}`
        do
            echo "samtools view -h -@ ${usedCompressionThreads} -b ${inputBAM} $(sed -n ${dollar}{i}p ${shardBED} | bed_to_samtools_region) > ${outbase}.shard.${dollar}{i}.bam" >> jfile.txt
        done && \
        python launcher.py -i jfile.txt -c 1 -n ${usedThreads} 
    >>>


    runtime{
        docker : "erictdawson/samtools"
        cpu : "${usedThreads}"
        memory : selectedMem + 1.5 + " GB"
        disks : "local-disk " + diskGB + " HDD"
        preemptible : 3
    }

    output{
        Array[File] bamShards = glob("${outbase}.shard.*.bam")
    }
}

workflow dummyflow{
    
}