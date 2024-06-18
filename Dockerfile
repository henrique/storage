FROM ubuntu:22.04

# Add contents of the current directory to /workspace/dlio in the container
ADD . /workspace/storage

WORKDIR /workspace/storage
RUN rm -rf .git

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git vim sysstat mpich gcc-10 g++-10 libc6 libhwloc-dev python3.10 python3-pip python3-venv
RUN python3 -m pip install --upgrade pip
RUN python3 -m venv /workspace/venv
ENV PATH="/workspace/venv/bin:$PATH"
RUN pip3 install -r dlio_benchmark/requirements.txt
