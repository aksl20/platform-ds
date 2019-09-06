
# Ubuntu 16.04 (xenial) from 2017-07-23
# https://github.com/docker-library/official-images/commit/0ea9b38b835ffb656c497783321632ec7f87b60c
FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

MAINTAINER DataLab 195 <axel.camara@soprasteria.com>
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

USER root

#ENV http_proxy http://10.8.3.69:8080
#ENV https_proxy http://10.8.3.69:8080
ENV NO_PROXY 172.19.0.4,172.19.0.3,172.17.0.1,jupyterhub
ENV no_proxy 172.19.0.4,172.19.0.3,172.17.0.1,jupyterhub

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --fix-missing && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    run-one \
    fonts-liberation \
    build-essential \
    curl \
    libfreetype6-dev \
    libzmq3-dev \
    pkg-config \
    python \
    python3-dev \
    rsync \
    r-base \
    software-properties-common \
    unzip \
    libgtk2.0-0 \
    git \
    tcl-dev \
    vim \
    tig \
    tk-dev \
    libgl1-mesa-glx \
    openjdk-8-jdk \
    ssh \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

ADD scripts/fix-permissions /usr/local/bin/fix-permissions
RUN chmod +x /usr/local/bin/fix-permissions

# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Create jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME && \
    fix-permissions "$(dirname $CONDA_DIR)"

USER $NB_UID
WORKDIR $HOME

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER

# Install conda as jovyan and check the md5 sum provided on the download site
ENV MINICONDA_VERSION=4.6.14 \
    CONDA_VERSION=4.7.10

RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "718259965f234088d785cad1fbd7de03 *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda install --quiet --yes conda && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install Tini
RUN conda install --quiet --yes 'tini=0.18.0' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# COPY environment.yml  $HOME/environment.yml
RUN conda install --quiet --yes \
    numpy \
    matplotlib \
    jupyter \
    opencv \
    pillow \
    scikit-learn \
    scikit-image \
    scipy \
    pip \
    h5py \
    eventlet \
    flask-socketio \
    seaborn \
    pandas \
    ffmpeg \
    imageio \
    notebook=6.0.0 \
    jupyterhub=1.0.0 \
    jupyterlab \
    tornado \
    r-essentials && \
    jupyter labextension install @jupyterlab/hub-extension && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    fix-permissions $CONDA_DIR

RUN pip install tensorflow-gpu==1.14.0 \
      tensorflow==1.14.0 \
      pyspark \
      findspark \
      keras==2.2.4 \
      mlflow && \
    fix-permissions $CONDA_DIR

USER root

EXPOSE 8888
WORKDIR $HOME

#add proxy env variable from build command : docker build --build-arg http_proxy --build-arg https_proxy -t datalab195/base_notebook .
ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY scripts/start.sh /usr/local/bin/
COPY scripts/start-notebook.sh /usr/local/bin/
COPY scripts/start-singleuser.sh /usr/local/bin/
COPY scripts/systemuser.sh /usr/local/bin/
COPY scripts/jupyter_notebook_config.py /etc/jupyter/

RUN fix-permissions /etc/jupyter/

RUN chmod +x /usr/local/bin/start.sh \
	/usr/local/bin/start-notebook.sh \
	/usr/local/bin/start-singleuser.sh \
	/usr/local/bin/systemuser.sh 

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
