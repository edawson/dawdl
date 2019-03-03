## Extract reads of interest from a BAM file
## using VariantBam (github.com/walaj/variantbam,
## though github.com/edawson/variantbam is the version used)
## according to a set of rules defined by a JSON file.
import "https://github.com/edawson/dawdl/tasks/variantbam.tasks.wdl"
import "https://github.com/edawson/dawdl/tasks/samtools.tasks.wdl"


workflow VariantBamExtract{
    File BAM
    File BAI
    File rules
    String label
    Int? threads
    Int? memory_per_thread

    Int numthreads = select_first([threads, 0])
    # Compute disk size
    Int diskGB = ceil((size(BAM, "GB") * 1.2) + size(BAI, "GB"))

    call VariantBamExtract{
        input:
            bam=BAM,
            bamIndex=BAI,
            rulesJSON=rules,
            label=label,
            threads=numthreads,
            diskGB=diskGB
    }

    Int smallerDiskGB = ceil(size(VariantBamExtract.variantbam_extracted_bam, "GB") * 1.4)

    call SamtoolsSort{
        input:
            inputBAM=VariantBamExtract.variantbam_extracted_bam,
            threads=threads,
            diskGB=smallerDiskGB,
            memory_per_thread=memory_per_thread,
            preemptible_attempts=1
    }
    
}