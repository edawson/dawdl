FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN git clone --recursive https://github.com/edawson/rkmh && \
    cd rkmh && \
    make && \
    cp rkmh /usr/bin
