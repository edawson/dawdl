## Extract reads of interest from a BAM file
## using VariantBam (github.com/walaj/variantbam,
## though github.com/edawson/variantbam is the version used)
## according to a set of rules defined by a JSON file.
import "https://api.firecloud.org/ga4gh/v1/tools/erictdawson%3Avariantbam-tasks/versions/5/plain-WDL/descriptor" as vbam
import "https://api.firecloud.org/ga4gh/v1/tools/erictdawson%3Asamtools-tasks/versions/4/plain-WDL/descriptor" as samtools


workflow VariantBamExtract{
    File BAM
    File BAI
    File rules
    String label
    Int? threads
    Int? memory_per_thread

    Int numthreads = select_first([threads, 0])
    # Compute disk size
    Int diskGB = ceil((size(BAM, "GB") * 2) + size(BAI, "GB"))

    call vbam.VariantBamExtractTask{
        input:
            bam=BAM,
            bamIndex=BAI,
            rulesJSON=rules,
            label=label,
            threads=numthreads,
            diskGB=diskGB
    }

    Int smallerDiskGB = ceil(size(VariantBamExtractTask.variantbam_extracted_bam, "GB") * 1.4)

    call samtools.SamtoolsSortTask{
        input:
            inputBAM=VariantBamExtractTask.variantbam_extracted_bam,
            threads=threads,
            diskGB=smallerDiskGB,
            memoryPerThread=memory_per_thread,
            preemptible_attempts=1
    }
    
}
