FROM ubuntu:22.04
LABEL maintainer="Eric T Dawson"

ARG SAMTOOLS_VERSION=1.15

RUN  export DEBIAN_FRONTEND=noninteractive && \
echo "America/New_York" > /etc/timezone && \
apt-get update &&  apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    curl \
    gawk \
    gcc \
    git \
    gnupg \
    libcurl4-gnutls-dev \
    libssl-dev \
    libncurses5-dev \
    libbz2-dev \
    liblzma-dev \
    ldc \
    pigz \
    tar \
    wget \
    zlib1g-dev \
    zlib1g && \
rm -rf /var/lib/apt/lists/*

RUN mkdir /app
RUN mkdir /build
WORKDIR /build

RUN git clone https://github.com/edawson/LaunChair.git && \
    mv LaunChair/LaunChair.py /usr/bin/ && \
    mv LaunChair/launcher.py /usr/bin/ && \
    rm -rf LaunChair

#RUN wget http://zlib.net/pigz/pigz-2.7.tar.gz && \
#    tar xzf pigz-2.7.tar.gz && \
#    cd pigz-2.7 && \
#    make && \
#    mv pigz /usr/bin/ && \
#    mv unpigz /usr/bin/ && \
#    rm -rf pigz-2.4.tar.gz pigz-2.4

RUN wget https://github.com/samtools/htslib/releases/download/${SAMTOOLS_VERSION}/htslib-${SAMTOOLS_VERSION}.tar.bz2 && \
    tar xfj htslib-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd htslib-${SAMTOOLS_VERSION} && \
    make -j 4 && \
    make install && \
    rm -rf htslib-${SAMTOOLS_VERSION}.tar.bz2

RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    tar xfj samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION} && make -j 4 && \
    make install && \
    rm -rf samtools-${SAMTOOLS_VERSION}.tar.bz2

RUN wget https://github.com/samtools/bcftools/releases/download/${SAMTOOLS_VERSION}/bcftools-${SAMTOOLS_VERSION}.tar.bz2 && \
    tar xjf bcftools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd bcftools-${SAMTOOLS_VERSION} && \
    make -j 4 && \
    make install && \
    rm -rf bcftools-${SAMTOOLS_VERSION}.tar.bz2

RUN git clone https://github.com/edawson/helpy.git && \
    mv helpy/* /usr/bin/ && \
    rm -rf helpy

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
ENV PATH=/usr/bin/:$PATH

RUN git clone --recursive https://github.com/edawson/interleave-fastq && \
    chmod 777 interleave-fastq/interleave-fastq && \
    mv interleave-fastq/interleave-fastq /usr/bin/ && \
    rm -rf interleave-fastq
