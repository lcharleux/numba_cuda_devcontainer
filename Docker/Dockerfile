ARG BASE_IMAGE=ubuntu:focal-20221130
FROM ${BASE_IMAGE}

# BASIC LIBRARIES
RUN apt-get update && \ 
     # apt install -y build-essential && \
     apt-get install -y wget &&\
     apt-get clean && \
     rm -rf /var/lib/apt/lists/* 

# MINICONDA3 INSTALL
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p $CONDA_DIR

# CONDA ENV SETUP
ENV PATH=$CONDA_DIR/bin:$PATH

SHELL ["/bin/bash", "--login", "-c"]

RUN conda create -y -n awesome -c rapidsai -c conda-forge -c nvidia  \
    rapids=22.12 python=3.9 cudatoolkit=11.5 \
    jupyterlab dask-sql dash graphistry pycaret xarray-spatial

ENV CONDA_ENV_NAME awesome

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate $CONDA_ENV_NAME" >> ~/.bashrc 
   
SHELL ["/bin/bash", "--login", "-c"]

