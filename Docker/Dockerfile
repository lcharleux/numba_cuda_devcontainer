ARG BASE_IMAGE=ubuntu:focal-20221130
FROM ${BASE_IMAGE}

# BASIC LIBRARIES
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/London"
RUN apt-get update && \
    apt-get install -y git wget sudo cmake libncurses5-dev libncursesw5-dev build-essential && \
    apt-get clean

# MINICONDA3 INSTALL
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh
ENV CONDA_BIN_PATH /opt/conda/condabin/conda


# CONDA ENV SETUP
#ENV PATH=$CONDA_DIR/bin:$PATH
ENV CONDA_ENV_NAME awesome

SHELL ["/bin/bash", "--login", "-c"]

# RUN ${CONDA_BIN_PATH} create -y -n awesome -c rapidsai -c conda-forge -c nvidia  \
#     rapids=22.12 python=3.9 cudatoolkit=11.5 \
#     jupyterlab dask-sql dash graphistry pycaret xarray-spatial

# CONDA ENV CREATION
RUN ${CONDA_BIN_PATH} create -y -n awesome
COPY environment.yml /tmp/environment.yml
RUN ${CONDA_BIN_PATH} env update --file /tmp/environment.yml

# PYTORCH INSTALL
RUN /opt/conda/envs/awesome/bin/pip install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html

# NVTOP INSTALL
RUN cd /tmp \
    && git clone https://github.com/Syllo/nvtop.git \
    && mkdir -p nvtop/build && cd nvtop/build \
    && cmake .. -DNVIDIA_SUPPORT=ON -DAMDGPU_SUPPORT=OFF -DINTEL_SUPPORT=OFF \
    && make install

# HTOP INSTALL
RUN apt-get install -y htop

COPY tests /tmp/tests

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "${CONDA_BIN_PATH} activate $CONDA_ENV_NAME" >> ~/.bashrc

SHELL ["/bin/bash", "--login", "-c"]
