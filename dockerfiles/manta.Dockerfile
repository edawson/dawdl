FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN wget https://github.com/Illumina/manta/releases/download/v1.5.0/manta-1.5.0.release_src.tar.bz2 && \
    tar xjf manta-1.5.0.release_src.tar.bz2 && \
    mkdir build && \
    cd build && \
    ../manta-1.5.0.release_src/configure --jobs=1 --prefix=/usr/bin && \
    make install