FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN git clone --recursive https://github.com/edawson/svaha2 && \
    cd svaha2 && \
    make cloud && \
    cp svaha2 /usr/local/bin/
