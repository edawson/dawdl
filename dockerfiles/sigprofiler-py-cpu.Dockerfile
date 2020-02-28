FROM erictdawson/base
LABEL maintainer="Eric T Dawson"
WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip

RUN pip3 install SigProfilerExtractor==1.0.3 SigProfilerMatrixGenerator==1.1.5

Run echo

RUN git clone --recursive https://github.com/edawson/SigProfilerHelper && \
    cp SigProfilerHelper/generate_matrix.py /usr/bin/ && \
    cp SigProfilerHelper/run_sigprofiler.py /usr/bin/ && \
    cp SigProfilerHelper/install_reference.py /usr/bin/

RUN python3 /usr/bin/install_reference.py -r GRCh37
    #echo "from SigProfilerMatrixGenerator import install as genInstall" >> force_install.py && \
    #echo "if __name__ == \"main\":" >> force_install.py && \
    #echo "	genInstall.install('GRCh37', rsync=False, bash=True)" >> force_install.py && \
