FROM erictdawson/tidyverse
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN apt-get update && apt-get install -y \
    python-dev \
    python-pip


RUN wget https://pypi.python.org/packages/cf/41/636795b48c84fb8331710e9f6e948b2b9d0a3123c7fdaac62b061411de0a/telomerehunter-1.0.4.tar.gz && \
    tar xvzf telomerehunter-1.0.4.tar.gz && \
    cd telomerehunter-1.0.4/ && \
    python setup.py build && \
    python setup.py install
