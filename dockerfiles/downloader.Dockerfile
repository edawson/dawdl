#FROM google/cloud-sdk:fe3a307b3f62
FROM google/cloud-sdk:slim
RUN apt-get install -yy axel
RUN apt-get install -yy aria2
