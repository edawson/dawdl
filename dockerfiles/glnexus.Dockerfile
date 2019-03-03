FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive
ARG git_revision=master
ARG build_type=Release

# dependencies
RUN apt-get -qq update && \
        apt-get -qq install -y --no-install-recommends --no-install-suggests \
        curl wget ca-certificates git-core less netbase \
        g++ cmake autoconf make file valgrind \
        libjemalloc-dev libzip-dev libsnappy-dev libbz2-dev zlib1g-dev liblzma-dev libzstd-dev \
        python-pyvcf

# clone GLnexus repo on the desired git revision
WORKDIR /
RUN git clone https://github.com/dnanexus-rnd/GLnexus.git
WORKDIR /GLnexus
RUN git fetch --tags origin && git checkout "$git_revision" && git submodule update --init --recursive

# compile GLnexus
RUN cmake -DCMAKE_BUILD_TYPE=$build_type . && make -j4 && cp glnexus_cli /usr/bin/