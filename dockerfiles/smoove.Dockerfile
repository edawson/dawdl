FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN wget https://github.com/brentp/smoove/releases/download/v0.2.3/smoove && chmod 777 smoove && mv smoove /usr/bin/
RUN wget https://github.com/brentp/mosdepth/releases/download/v0.2.4/mosdepth && chmod 777 mosdepth && mv mosdepth /usr/bin/
RUN wget https://github.com/brentp/duphold/releases/download/v0.1.2/duphold && chmod 777 duphold && mv duphold /usr/bin/
RUN wget https://github.com/arq5x/lumpy-sv/releases/download/0.3.0/lumpy-sv.tar.gz && \
 tar xvzf lumpy-sv.tar.gz && \
 cd lumpy-sv && \
 make && \
 cp bin/* /usr/bin/

RUN wget https://github.com/brentp/gsort/releases/download/v0.0.6/gsort_linux_amd64 && \
    mv gsort_linux_amd64 gsort && \
    chmod 777 gsort && \
    mv gsort /usr/bin/

RUN pip install git+https://github.com/hall-lab/svtyper.git && \
    pip install svtools