FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN wget https://github.com/edawson/telomerecat/archive/3.2.1.tar.gz && \
    tar xvzf 3.2.1.tar.gz && \
    cd telomerecat-3.2.1 && \
    python setup.py build && \
    python setup.py install
