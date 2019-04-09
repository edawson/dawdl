FROM continuumio/miniconda
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN conda install scipy numpy

FROM erictdawson/base
