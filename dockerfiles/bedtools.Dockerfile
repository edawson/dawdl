FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.27.1/bedtools-2.27.1.tar.gz && \
    tar xvzf bedtools-2.27.1.tar.gz && \
    cd bedtools2 && \
    make -j 4 && \
    make install

RUN wget -O split_bed_by_reads https://github.com/papaemmelab/split_bed_by_reads/releases/download/0.1.0/split_bed_by_reads && \
chmod +x split_bed_by_reads && mv split_bed_by_reads /usr/bin/

RUN wget -O split_bed_by_index https://github.com/papaemmelab/split_bed_by_index/releases/download/0.1.0/split_bed_by_index && \
chmod +x split_bed_by_index && mv split_bed_by_index /usr/bin/
