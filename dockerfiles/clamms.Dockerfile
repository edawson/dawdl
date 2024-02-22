FROM erictdawson/base

WORKDIR /app
RUN git clone https://github.com/rgcgithub/clamms.git && \
    cd clamms && \
    make

ENV CLAMMS_DIR=/app/clamms