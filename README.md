dawdl: A WDL library of bioinformatics tasks
----------------------------------------------
Eric T Dawson  
March 2019

## Introduction
[WDL](https://github.com/openwdl/wdl/blob/master/versions/1.0/SPEC.md) is a Worfklow Description Language
developed by the Broad Institute and used as the backend to their FireCloud analysis platform.
[dawdl](https://github.com/edawson/dawdl) is a collection of tasks, workflows, and Dockerfiles I have
written for the platform. It contains many common bioinformatics workflows (e.g. sort and index a BAM) as
well as more specialized software, including variant / SV callers.

## Dockerfiles
All of the Dockerfiles in the [dockerfiles](https://github.com/edawson/dawdl/tree/master/dockerfiles)
directory are built on top of a single base Dockerfile. The [build_all](https://github.com/edawson/dawdl/blob/master/build_all.sh)
script builds and tags these images for each tool, then pushes them to [my Dockerhub](https://hub.docker.com/u/erictdawson) under
the prefix of their name. I have tried to keep them small, so each Dockerfile will in general build only a single tool.

The Dockerfiles defined here all follow the following conventions:
1. They are named after the single tool they are designed to wrap.
2. They contain only the tools they require to complete relevant tasks (i.e. no cruft).
3. They are tagged with the name of the tool they wrap, and pushed to a Dockerhub repo at `erictdawson/<tool-name>`.
4. They have no ENTRYPOINT or CMD defined (i.e. they call `bash` when run). This is essential when targeting them
to run on FireCloud.

All of these should be publicly available as both the Dockerfiles and images.


## Tasks
Tasks are defined in the task directory. A WDL task usually defines a small unit of work (e.g. index a BAM file) that may
be part of a larger workflow composed of many tasks.

In dawdl, the [tasks](https://github.com/edawson/dawdl/blob/master) directory contains tasks for various tools. Tasks for the same
tool are defined in a single file named for the base command (e.g. `samtools sort` and `samtools index` are defined in `samtools.wdl).

To be pushed to FireCloud, WDLs must contain a workflow definition, so all the tasks here have a dummy workflow definition at the
bottom of the WDL.

## Workflows
Workflows are composed of tasks linked together by "plumbing," which describes the order and dependencies of component tasks. Where possible, I have implemented parallelization in workflows using the Scatter-Gather paradigm described in WDL.

There are many considerations to take into account when building up workflows:  
1. FireCloud has a five-day runtime limit, so a workflow should be designed to finish in less than that time.
2. FireCloud can use preemptible compute instances for significant cost savings. However, preemptible instances
may be killed to run higher-priority jobs, so anything running in a preemptible should run in as little time
as possible to ensure it has a high probability of actually finishing. Conclusion: shorter-running tasks
are preferred over long-running ones where possible.
3. Some tasks can be parallelized by chromosome or region. However, others (such as translocation structurcal variant callers)
have depencies across the entire genome. This should be considered when running on input data that may or not be whole genome.
4. Transferring data costs time and money in FireCloud, so it is better to move a small file than move a large file and compute on just
a portion of it.


## Getting help
Please post an issue on [the github](https://github.com/edawson/dawdl) for support.