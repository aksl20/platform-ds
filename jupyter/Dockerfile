ARG LOCAL_IVY=no

FROM jupyter/pyspark-notebook as coursier_base

USER root

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
      curl \
      openjdk-8-jre-headless \
      ca-certificates-java && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -Lo /usr/local/bin/coursier https://github.com/coursier/coursier/releases/download/v2.0.0-RC3-2/coursier && \
    chmod +x /usr/local/bin/coursier

USER $NB_UID

# ensure the JAR of the CLI is in the coursier cache, in the image
RUN /usr/local/bin/coursier --help

FROM coursier_base as local_ivy_yes
USER $NB_UID
ONBUILD RUN mkdir -p .ivy2/local/
ONBUILD COPY --chown=1000:100 ivy-local/ .ivy2/local/

FROM coursier_base as local_ivy_no

FROM local_ivy_${LOCAL_IVY}
ARG ALMOND_VERSION
# Set to a single Scala version string or list of Scala versions separated by a space.
# i.e SCALA_VERSIONS="2.12.9 2.13.0"
ARG SCALA_VERSIONS

USER root
COPY scripts/install-kernels.sh .
RUN chmod +x install-kernels.sh

USER $NB_UID
RUN ./install-kernels.sh && \
    rm install-kernels.sh && \
    rm -rf .ivy2

