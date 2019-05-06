FROM erictdawson/base
MAINTAINER Eric T. Dawson

RUN set -e \
      && apt-get -y update \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https apt-utils ca-certificates gnupg \
      && echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" \
        > /etc/apt/sources.list.d/r.list \
      && apt-key adv --keyserver keyserver.ubuntu.com \
        --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        curl g++ gcc gfortran git make libblas-dev libcurl4-gnutls-dev \
        liblapack-dev libmariadb-client-lgpl-dev libpq-dev librsvg2-bin \
        libsqlite3-dev libssh2-1-dev libssl-dev libxml2-dev locales pandoc \
        r-base \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && locale-gen en_US.UTF-8 \
      && update-locale


RUN echo 'install.packages(c("cowplot", "devtools", "ggbeeswarm", "ggrepel", "tidyverse", "rmarkdown"))' > /usr/bin/install_packages.r && \
    Rscript /usr/bin/install_packages.r
