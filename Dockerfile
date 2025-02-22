FROM ubuntu:22.04

# Prep install and update
RUN apt-get update && apt-get install -y apt-transport-https

# Install some utilities
RUN apt-get update
RUN apt-get install -y -q wget git libxrender1 libsm6 bzip2
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install miniconda
RUN MINICONDA="Miniconda3-latest-Linux-x86_64.sh" && \
    wget --quiet https://repo.continuum.io/miniconda/$MINICONDA && \
    bash $MINICONDA -b -p /miniconda && \
    rm -f $MINICONDA && \
    echo ". /miniconda/etc/profile.d/conda.sh" >> ~/.bashrc
ENV PATH /miniconda/bin:$PATH

SHELL ["/bin/bash", "-c"]

# install deepchem with master branch
RUN conda update -n base conda && \
    git clone --depth 1 https://github.com/deepchem/deepchem.git && \
    cd deepchem && \
    source scripts/light/install_deepchem.sh 3.10 cpu common && \
    conda activate deepchem && \
    pip install -e . && \
    conda clean -afy && \
    rm -rf ~/.cache/pip

RUN echo "conda activate deepchem" >> ~/.bashrc
WORKDIR /root/mydir
