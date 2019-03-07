FROM erictdawson/freebayes
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN pip install \
    numpy \
    PyVCF \
    ConfigParser \
    Cheetah \
    pysam
RUN pip install fisher


RUN git clone https://github.com/edawson/bam-matcher.git && cd bam-matcher && chmod 777 bam-matcher-wrapper.sh
ENV PATH=$PATH:/app/bam-matcher/
