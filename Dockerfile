FROM python:3.10.14

RUN apt-get update && apt-get install -y \
        build-essential             \
        wget                        \
        ca-certificates             \
        --no-install-recommends     \
    && rm -rf /var/lib/apt/lists/*

# Install MPICH
RUN wget -q http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz \
    && tar xf mpich-3.1.4.tar.gz \
    && cd mpich-3.1.4 \
    && ./configure --disable-fortran --enable-fast=all,O3 --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mpich-3.1.4 \
    && rm mpich-3.1.4.tar.gz

# Add contents of the current directory to /workspace in the container
ADD . /workspace/storage

WORKDIR /workspace/storage
RUN rm -rf .git

RUN pip3 install --upgrade pip
RUN python3 -m venv /workspace/venv
ENV PATH="/workspace/venv/bin:$PATH"
RUN pip3 install -r dlio_benchmark/requirements.txt
