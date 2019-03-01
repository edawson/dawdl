FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN git clone --recursive https://github.com/edawson/freebayes && cd freebayes && make && cp scripts/* /usr/bin/
