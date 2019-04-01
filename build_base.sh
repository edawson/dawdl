#!/bin/bash
docker build -t erictdawson/base -f base/base.Dockerfile --no-cache ./dockerfiles && \
docker push erictdawson/base
