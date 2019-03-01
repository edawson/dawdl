#!/bin/bash
docker build -t erictdawson/base -f base.Dockerfile . && \
docker push erictdawson/base
