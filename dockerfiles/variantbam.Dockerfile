FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN git clone --recursive https://github.com/edawson/variantbam && \
    cd variantbam && \
    ./configure && \
    make && \
    make install && \
    rm -rf variantbam