ARG BASE_IMAGE=numba_cuda:latest
FROM ${BASE_IMAGE}

# ARGS
ARG USER_NAME
ARG USER_UID
ARG USER_GID
ARG CONDA_ENV_NAME
ARG DISPLAY

# ENV VARIABLES
ENV USER_NAME=${USER_NAME}
ENV USER_GID=${USER_GID}
ENV USER_UID=${USER_UID}
ENV CONDA_ENV_NAME=${CONDA_ENV_NAME}
ENV CONDA_ENV_PATH=/opt/conda/envs/${CONDA_ENV_NAME}/bin/
ENV DISPLAY=$DISPLAY

RUN apt-get update && apt-get install -y x11-apps xauth x11-xserver-utils
RUN apt-get update && apt-get install -y libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-render-util0-dev libxcb-xkb-dev libxkbcommon-x11-0

# POST-COMMAND FILES
COPY ./postCreateCommands.sh /tmp/postCreateCommands.sh
COPY ./my_environment.yml /tmp/my_environment.yml
COPY ./Project.toml /tmp/Project.toml
COPY ./Manifest.toml /tmp/Manifest.toml

ENV JULIA_VERSION=1.9.0
ENV JULIA_RELEASE=1.9

RUN wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_RELEASE}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    tar zxvf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C opt && \
    cd /opt && \
    mv julia-${JULIA_VERSION} julia

# USER CREATION
RUN groupadd --gid $USER_GID $USER_NAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USER_NAME

RUN echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME \
    && chmod 0440 /etc/sudoers.d/$USER_NAME

RUN cd / && mkdir python_packages

# Log as $USER and create a .bashrc file for config
USER ${USER_UID}:${USER_GID}

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate $CONDA_ENV_NAME" >> ~/.bashrc && \
    echo "export PYTHONPATH=\$PYTHONPATH:/python_packages/" >> ~/.bashrc && \
    echo "export PATH=\$PATH:/opt/julia/bin" >> ~/.bashrc

RUN echo "alias sudo='sudo env PATH=\$PATH'" >> ~/.bashrc


SHELL ["/bin/bash", "--login", "-c"]
RUN /bin/bash ~/.bashrc
# ENTRYPOINT ["/bin/bash"]
