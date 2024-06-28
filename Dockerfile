FROM docker.io/python:3.10.14

ARG MPICH_VERSION=4.2.1

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        wget \
        libhwloc-dev \
        ca-certificates \
        --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install MPICH
RUN wget -q http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz && \
    tar xf mpich-${MPICH_VERSION}.tar.gz && \
    cd mpich-${MPICH_VERSION} && \
    ./configure --with-device=ch4:ofi --disable-fortran --prefix=/usr && \
    make -j $(nproc) && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf mpich-${MPICH_VERSION} && \
    rm mpich-${MPICH_VERSION}.tar.gz

# Add contents of the current directory to /workspace in the container
ADD . /workspace/storage

WORKDIR /workspace/storage
RUN rm -rf .git

RUN pip3 install --upgrade pip && \
    pip3 install -r dlio_benchmark/requirements.txt

