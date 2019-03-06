FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN pip install \
    numpy \
    PyVCF \
    ConfigParser \
    Cheetah \
    pysam
RUN pip install fisher


RUN git clone https://github.com/edawson/bam-matcher.git
ENV PATH=$PATH:/app/bam-matcher/
