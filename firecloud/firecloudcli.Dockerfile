FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
    curl \
    git \
    python \
    python-pip \
    python-setuptools && \
    apt-get -yq autoremove && \
    apt-get -yq clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

RUN curl https://sdk.cloud.google.com | bash
ENV PATH="/root/google-cloud-sdk/bin:$PATH"
# Tell gcloud to save state in /.config so it's easy to override as a mounted volume.

RUN git clone --recursive https://github.com/broadinstitute/fiss.git /fiss && \
    cd fiss && \
    pip install --no-cache-dir -U --upgrade-strategy eager /fiss

RUN mkdir /work
WORKDIR /work
