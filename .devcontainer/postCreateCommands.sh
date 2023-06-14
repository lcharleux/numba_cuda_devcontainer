#!/bin/bash
echo "Start Devcontainer post-command process !"

#cd ../workspace/
# echo "Installing pre-commit"
# echo $CONDA_ENV
# ${CONDA_ENV_PATH}pre-commit install
# ${CONDA_ENV_PATH}pre-commit install-hooks
# echo "Devcontainer post-command process done !"

echo "Running unit tests"
/opt/conda/envs/awesome/bin/pytest /tmp/tests


echo "Installing custom Python packages from my_environment.yml file."
if [ -e /tmp/my_environment.yml ]
then
    sudo conda env update --file /tmp/my_environment.yml
else
    echo "no my_environment.yml file"
fi

echo "Is Julia well installed?"
if [ -e /opt/julia ]
then
    echo "Yes, great!"
    /opt/julia/bin/julia -e "using Pkg; Pkg.activate();"
    # cp ./my_project.toml ~/.julia/environments/v1.9/Project.toml
    # cp Project.toml ~/.julia/environments/v1.9/Project.toml
    /opt/julia/bin/julia -e "using Pkg; Pkg.instantiate('/tmp'); Pkg.update(); Pkg.precompile()"
else
    echo "No, it does not worked unfortunately"
fi

# echo "Installing custom Julia packages from Project.toml file."
# if [ -e /tmp/Project.toml ]
# then
#     # sudo /opt/julia/bin/julia env update --file /tmp/Project.toml
#     /opt/julia/bin/julia --project="/tmp/"
# else
#     echo "no Project.toml file and creating it"
#     cd /tmp
#     /opt/julia/bin/julia -e "using Pkg; Pkg.activate('.'); Pkg.add(['Example', 'JSON'])"
#     /opt/julia/bin/julia --project="."
# fi

echo "Terminated"
