FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN wget https://github.com/brentp/duphold/releases/download/v0.1.2/duphold && chmod 777 duphold && mv duphold /usr/bin/
