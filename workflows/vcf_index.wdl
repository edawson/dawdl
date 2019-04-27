# Slice a VCF using bedtools
# to restrict it to sites within a BAM file.
import "https://api.firecloud.org/ga4gh/v1/tools/erictdawson%3Avcf-tasks/versions/15/plain-WDL/descriptor" as index


workflow VCFIndexWorkflow{
    File inputVCF
    Int? memory
    Int? threads
    
    Int diskGB = ceil((size(inputVCF, "GB") * 2)) + 50

    call index.VCFIndexTask{
        input:
            inputVCF=inputVCF,
            memory=memory,
            threads=threads,
            diskGB=diskGB
    }
}
