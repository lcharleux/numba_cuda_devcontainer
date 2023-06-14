ARG BASE_IMAGE=numba_cuda_julia:latest
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
ENV DISPLAY=${DISPLAY}

# POST-COMMAND FILES
COPY ./postCreateCommands.sh /tmp/postCreateCommands.sh
COPY ./my_environment.yml /tmp/my_environment.yml
COPY ./my_project.toml /tmp/my_project.toml

# USER CREATION
RUN groupadd --gid $USER_GID $USER_NAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USER_NAME

RUN echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME \
    && chmod 0440 /etc/sudoers.d/$USER_NAME

RUN cd / && mkdir python_packages

RUN usermod -a -G video $USER_NAME
RUN usermod -a -G root $USER_NAME 

# Log as $USER and create a .bashrc file for config
USER ${USER_UID}:${USER_GID}

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate $CONDA_ENV_NAME" >> ~/.bashrc && \
    echo "export PYTHONPATH=\$PYTHONPATH:/python_packages/" >> ~/.bashrc && \
    echo "export PATH=\$PATH:/opt/julia/bin" >> ~/.bashrc

RUN echo "alias sudo='sudo env PATH=\$PATH'" >> ~/.bashrc

SHELL ["/bin/bash", "--login", "-c"]
RUN /bin/bash ~/.bashrc

# JULIE ENV
#create the .julia directory
# RUN opt/julia/bin/julia -e "using Pkg; Pkg.activate(); Pkg.instantiate();"
#     # mkdir ~/.julia/environments/awesomeJulia
# COPY ./Project.toml ~/.julia/environments/v1.9/Project.toml
# RUN cd ~/.julia/environments/v1.9
# RUN opt/julia/bin/julia -e 'using Pkg; Pkg.instantiate(); Pkg.update();'
# RUN opt/julia/bin/julia -e 'using Pkg; Pkg.activate("awesomeJulia", shared=true); Pkg.instantiate()'
# COPY ./Project.toml ~/.julia/environments/awesomeJulia/Project.toml
# RUN /opt/julia/bin/julia --project="/tmp/Project.toml" -e 'using Pkg; Pkg.activate("awesomeJulia", shared=true); Pkg.instantiate(); Pkg.precompile();'
# RUN /opt/julia/bin/julia --project="/tmp/awesomeJulia" -e "using Pkg; Pkg.instantiate(); Pkg.precompile();"

# RUN /opt/julia/bin/julia -e "using Pkg; Pkg.activate('~/.julia/environments/awesomeJulia');"

# COPY ./Project.toml ~/.julia/environments/awesomeJulia/Project.toml

# RUN /opt/julia/bin/julia -e "using Pkg; Pkg.activate('awesomeJulia'); Pkg.instantiate()" 

# JULIA ENV 
# RUN /opt/julia/bin/julia -e "using Pkg; Pkg.instantiate()" 
# RUN cd /tmp && \
#     /opt/julia/bin/julia -e "using Pkg; Pkg.instantiate(); Pkg.precompile()"

# ENTRYPOINT ["/bin/bash"]
