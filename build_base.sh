#!/bin/bash
docker build -t erictdawson/base -f dockerfiles/base.Dockerfile ./dockerfiles && \
docker push erictdawson/base
