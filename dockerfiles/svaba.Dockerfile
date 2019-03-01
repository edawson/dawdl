FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN git clone --recursive https://github.com/walaj/svaba.git && \
    cd svaba && \
    ./configure && \
    make && \
    make install && \
    rm -rf svaba