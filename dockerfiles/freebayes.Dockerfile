FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN git clone --recursive https://github.com/edawson/freebayes && \
    cd freebayes && \
    make && \
    cp scripts/* /usr/bin/ && \
    cp bin/* /usr/bin/ && \
    cd vcflib && \
    make && \
    cp bin/* /usr/bin/ && \
    cp scripts/* /usr/bin/

