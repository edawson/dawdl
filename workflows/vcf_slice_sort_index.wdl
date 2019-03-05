## Sorts a given VCF file and then indexes it,
## Returning a bgzip compressed VCF and a TBI index.
## input VCF may be sorted or not, bgzipped or not.
import "https://api.firecloud.org/ga4gh/v1/tools/erictdawson%3Avcf-tasks/versions/12/plain-WDL/descriptor" as vcfTasks

workflow SortAndIndexVCF{
    File inputVCF
    File restrictBED
    Int threads

    Int diskGB = ceil((size(inputVCF, "GB") * 2)) + 50
    

    call vcfTasks.VCFSortTask as firstSort{
        input:
            inputVCF = inputVCF,
            diskGB = diskGB
    }

    Int secondDiskSize = ceil(size(firstSort.sortedVCF, "GB"))

    call vcfTasks.VCFIndexTask as firstIndex{
        input:
            inputVCF=firstSort.sortedVCF,
            diskGB=secondDiskSize
    }

    Int sliceDiskSZ = ceil(size(firstIndex.indexedVCFgz, "GB") * 2) + 50

    call vcfTasks.VCFSliceTask as sliceTask{
        input:
            inputVCF=firstIndex.indexedVCFgz,
            inputTBI=firstIndex.indexedVCFtbi,
            restrictBED=restrictBED,
            diskGB=sliceDiskSZ
    }

    call vcfTasks.VCFSortTask as finalSort{
        input:
            inputVCF = sliceTask.slicedVCF,
            diskGB = sliceDiskSZ
    }

    Int finalSortedSize = ceil(size(finalSort.sortedVCF, "GB") * 2) + 50

    call vcfTasks.VCFIndexTask as finalIndex{
        input:
            inputVCF=finalSort.sortedVCF,
            diskGB=finalSortedSize
    }


    
}