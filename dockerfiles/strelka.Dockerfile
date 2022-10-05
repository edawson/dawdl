FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app


RUN apt-add-repository universe && apt-get -y -qq update && apt-get -y -qq install python

RUN wget https://github.com/Illumina/strelka/releases/download/v2.9.10/strelka-2.9.10.release_src.tar.bz2 && \
    tar xvjf strelka-2.9.10.release_src.tar.bz2 && \
    mkdir -p build && \
    cd build && \
    rm -rf ./* && \
    ../strelka-2.9.10.release_src/configure --jobs=4 --prefix=/opt/ && \
    make install

ENV PATH opt/strelka/bin:$PATH 

