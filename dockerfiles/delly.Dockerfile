FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN apt-get update &&  apt-get install -y \
    libboost-all-dev

RUN wget https://github.com/dellytools/delly/archive/v0.8.1.tar.gz && tar xzf v0.8.1.tar.gz && cd delly-0.8.1/ && make PARALLEL=1 -B src/delly

