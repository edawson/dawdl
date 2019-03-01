#!/bin/bash

dockeruser="erictdawson"

for i in `find ./dockerfiles/ | grep "Dockerfile$" | grep -v "base.Dockerfile"`
  do
      echo "Building ${dockeruser}/$(basename $i .Dockerfile)" && \
      docker build -t ${dockeruser}/$(basename $i .Dockerfile) -f $i . && \
      docker push ${dockeruser}/$(basename $i .Dockerfile)
  done || exit 1
