version 1.0

task download_and_store {
    input {
        String fileLocation
        String gcpBucketLocation
    }

    String outfile = basename(fileLocation)
    command {
        axel "~{fileLocation}" && gsutil -m cp $(echo "~{outfile}" | cut -f 1 -d "?") "${gcpBucketLocation}" && touch finished.txt
    }
    runtime {

    }
    output {
        File dummyOutput = "finished.txt"
    }
}

workflow Downloader {
    input {
        String fileLocation
        String gcpBucketLocation
    }

    call download_and_store as download{
        input:
            fileLocation=fileLocation,
            gcpBucketLocation=gcpBucketLocation
    }
}
