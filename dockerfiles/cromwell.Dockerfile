FROM erictdawson/base
RUN wget https://github.com/broadinstitute/cromwell/releases/download/44/cromwell-44.jar && \
    mv cromwell-44.jar /usr/bin/cromwell.jar
