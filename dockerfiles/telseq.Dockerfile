FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app



RUN apt-get update && \
        apt-get install -y \
        automake \
        autotools-dev \
        build-essential \
        cmake \
        libhts-dev \
        libjemalloc-dev \
        libsparsehash-dev \
        libz-dev \
        python-matplotlib \
        wget \
        zlib1g-dev

# build remaining dependencies:
# bamtools
RUN wget https://github.com/pezmaster31/bamtools/archive/v2.5.1.tar.gz && \
    tar -xzvf v2.5.1.tar.gz && \
    rm v2.5.1.tar.gz && \
    cd bamtools-2.5.1 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install


# build telseq
RUN git clone https://github.com/edawson/telseq && \
    cd telseq/src && \
    ./autogen.sh && \
    ./configure --with-bamtools=/usr/local --prefix=/usr/local && \
    make && \
    make install

