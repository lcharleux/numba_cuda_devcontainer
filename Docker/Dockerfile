ARG BASE_IMAGE=ubuntu:focal-20221130
FROM ${BASE_IMAGE}

# BASIC LIBRARIES
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/London"
RUN apt-get update && \
    apt-get install -y git wget sudo cmake libncurses5-dev libncursesw5-dev build-essential ffmpeg libsm6 libxext6 libdrm-dev && \
    apt-get clean

RUN apt-get update && apt-get install -y x11-apps xauth 
RUN apt-get update && apt-get install -y libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-render-util0-dev libxcb-xkb-dev libxkbcommon-x11-0

# MINICONDA3 INSTALL
ARG CONDA_DIR='/opt/conda'
ARG CONDA_ENV_NAME='awesome'

ENV CONDA_DIR=$CONDA_DIR
ENV CONDA_ENV_NAME=$CONDA_ENV_NAME
ENV CONDA_ENV_PATH=$CONDA_DIR//envs/$CONDA_ENV_NAME
ENV CONDA_BIN_PATH=$CONDA_DIR/condabin/conda
ENV PATH=$CONDA_DIR/condabin/:$PATH
ENV CONDA_ENV_BIN_PATH $CONDA_DIR/envs/${CONDA_ENV_NAME}/bin
COPY environment.yml /tmp/environment.yml

RUN umask 000 && \
    mkdir -p ${CONDA_DIR} && \
    chmod 777 ${CONDA_DIR} && \
    apt-get update && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -ub -p $CONDA_DIR && \
    rm ~/miniconda.sh

# CONDA ENV CREATION
RUN umask 000 && \
    conda update -n base conda && \ 
    conda create -y -n $CONDA_ENV_NAME python=3.8

# CONDA ENV CREATION
RUN ${CONDA_BIN_PATH} create -y -n awesome
COPY environment.yml /tmp/environment.yml
RUN ${CONDA_BIN_PATH} env update --file /tmp/environment.yml

# JULIA INSTALL
ARG JULIA_DIR='/opt/julia'
ARG JULIA_ENV_NAME='awesomeJulia'
ARG JULIA_RELEASE='1.9'
ARG JULIA_VERSION=1.9.0

# ENV JULIA_DIR=$JULIA_DIR
# ENV JULIA_ENV_NAME=$JULIA_ENV_NAME
# ENV JULIA_ENV_PATH=$JULIA_DIR//envs/$JULIA_ENV_NAME
# ENV JULIA_BIN_PATH=$JULIA_DIR/juliabin/julia
# ENV PATH=$JULIA_DIR/juliabin/:$PATH
# ENV JULIA_ENV_BIN_PATH $JULIA_DIR/envs/${JULIA_ENV_NAME}/bin
COPY Project.toml /tmp/Project.toml

# RUN umask 000 && \
    # mkdir -p ${JULIA_DIR} && \
    # chmod 777 ${JULIA_DIR} && \
RUN wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_RELEASE}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    tar zxvf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C opt && \
    cd /opt && \
    mv julia-${JULIA_VERSION} julia
    # mv julia-${JULIA_VERSION}-linux-x86_64.tar.gz julia.tar.gz && \
    # mv opt/julia-${JULIA_VERSION} mv opt
    # mv ${JULIA_DIR}/julia-${JULIA_VERSION}/* ${JULIA_DIR} 
    # mv /opt/julia-${JULIA_VERSION} ${JULIA_DIR}
    # rm -r ${JULIA_DIR}/julia-${JULIA_RELEASE}
    # mv $JULIA_DIR/julia-${JULIA_RELEASE} $JULIA_DIR

# ENV JULIA_DIR =$JULIA_DIR
RUN cd /tests/ && \
    opt/julia/bin/julia -e 'using Pkg; Pkg.activate('.'); Pkg.instantiate(); Pkg.API.precompile()'
COPY Project.toml ~/.julia/environments/v${JULIA_RELEASE}/
ENV JULIA_DEPOT_PATH=~/.julia/environments/v${JULIA_RELEASE}/
COPY startup.jl tmp

# ENV JULIA_BIN_PATH /opt/julia-${JULIA_RELEASE}/bin/julia
# NVTOP INSTALL
RUN cd /tmp \
    && git clone https://github.com/Syllo/nvtop.git \
    && mkdir -p nvtop/build && cd nvtop/build \
    && cmake .. -DNVIDIA_SUPPORT=ON -DAMDGPU_SUPPORT=OFF -DINTEL_SUPPORT=OFF \
    && make install

# HTOP INSTALL
RUN apt-get install -y htop

# LOCALES UPDATE
RUN apt install locales && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales

COPY tests /tmp/tests

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate $CONDA_ENV_NAME" >> ~/.bashrc
    # echo "export PYTHONPATH=\$PYTHONPATH:/python_packages/" >> ~/.bashrc && \ 
    # echo "export PATH=\$PATH:$JULIA_DIR/bin" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]


