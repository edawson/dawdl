FROM erictdawson/base
MAINTAINER Eric T Dawson


RUN wget https://github.com/biod/sambamba/releases/download/v0.6.8/sambamba-0.6.8-linux-static.gz
RUN gunzip /app/sambamba-0.6.8-linux-static.gz
RUN mv /app/sambamba-0.6.8-linux-static /bin/sambamba && chmod 777 /bin/sambamba
RUN echo '<${2} xargs -n 1 -P 4 -tl -i{} sambamba slice -o {}.slice.bam ${1} {}' > /app/parallel_slice_helper.sh && \
    chmod 777 /app/parallel_slice_helper.sh && mv /app/parallel_slice_helper.sh /bin/

