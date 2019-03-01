FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.27.1/bedtools-2.27.1.tar.gz && \
    tar xvzf bedtools-2.27.1.tar.gz && \
    cd bedtools2 && \
    make -j 4 && \
    make install