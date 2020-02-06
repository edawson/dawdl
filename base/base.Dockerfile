FROM ubuntu:18.04
LABEL maintainer="Eric T Dawson"

RUN  export DEBIAN_FRONTEND=noninteractive && \
echo "America/New_York" > /etc/timezone && \
apt-get update &&  apt-get install -y \
    autoconf \
    automake \
    bc \
    build-essential \
    cmake \
    cpanminus \
    curl \
    dstat \
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
    python-dev \
    python-pip \
    python2.7 \
    r-base \
    tar \
    wget \
    zlib1g-dev \
    zlib1g && \
rm -rf /var/lib/apt/lists/*

RUN mkdir /app
RUN mkdir /build
WORKDIR /build

RUN cpanm Bio::Perl

RUN git clone https://github.com/edawson/LaunChair.git && mv LaunChair/LaunChair.py /usr/bin/ && mv LaunChair/launcher.py /usr/bin/

RUN wget http://zlib.net/zlib-1.2.11.tar.gz && \
    tar xzf zlib-1.2.11.tar.gz && \
    cd zlib-1.2.11 && \
    ./configure && \
    make && \
    make install
RUN wget http://zlib.net/pigz/pigz-2.4.tar.gz && \
    tar xzf pigz-2.4.tar.gz && \
    cd pigz-2.4 && \
    make && \
    mv pigz /usr/bin/ && \
    mv unpigz /usr/bin/

RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 && tar xfj htslib-1.9.tar.bz2 && cd htslib-1.9 && make -j 4 && make install && rm -rf htslib-1.9.tar.bz2
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && tar xfj samtools-1.9.tar.bz2 && cd samtools-1.9 && make -j 4 && make install && rm -rf samtools-1.9.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 && tar xjf bcftools-1.9.tar.bz2 && cd bcftools-1.9 && make -j 4 && make install && rm -rf bcftools-1.9.tar.bz2

RUN git clone https://github.com/edawson/helpy.git && mv helpy/* /usr/bin/

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
ENV PATH=/usr/bin/:$PATH

RUN git clone --recursive https://github.com/edawson/interleave-fastq && \
    chmod 777 interleave-fastq/interleave-fastq && \
    mv interleave-fastq/interleave-fastq /usr/bin/
