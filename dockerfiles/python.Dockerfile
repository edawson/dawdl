FROM continuumio/anaconda3:2020.11
LABEL maintainer="Eric T Dawson"
WORKDIR /app


RUN conda create --name python3.7 python=3.7
RUN echo "source activate python3.7" > ~/.bashrc
ENV PATH /opt/conda/envs/python3.7/bin:$PATH

