#!/bin/bash

for i in `find ./tasks | grep ".wdl$" | head -n 1`
do
    fissfc meth_new -d /work/sandbox/dawdl/tasks/$(basename $i) -n erictdawson -m $( echo $(basename $i .wdl) | sed "s/\./-/g")
done
