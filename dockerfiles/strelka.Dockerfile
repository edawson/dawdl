FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN wget https://github.com/Illumina/strelka/releases/download/v2.9.10/strelka-2.9.10.release_src.tar.bz2 && \
    tar xvjf strelka-2.9.10.release_src.tar.bz2 && \
    mkdir -p build && \
    cd build && \
    rm -rf ./* && \
    ../strelka-2.9.10.release_src/configure --jobs=1 --prefix=/usr/bin && make install

