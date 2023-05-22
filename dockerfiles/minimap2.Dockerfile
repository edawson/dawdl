FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

ARG MM2_VERSION=2.26

RUN wget https://github.com/lh3/minimap2/releases/download/v${MM2_VERSION}/minimap2-${MM2_VERSION}.tar.bz2 && \
    tar xjf minimap2-${MM2_VERSION}.tar.bz2 && \
    cd minimap2-${MM2_VERSION} && \
    make && \
    cp minimap2 /usr/bin
