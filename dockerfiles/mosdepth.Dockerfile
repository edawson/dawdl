FROM erictdawson/base
MAINTAINER Eric T Dawson

RUN wget https://github.com/brentp/mosdepth/releases/download/v0.2.4/mosdepth && chmod 777 mosdepth && mv mosdepth /usr/bin/