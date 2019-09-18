FROM python:3.7-stretch

ENV DAEMON_RUN=true
ENV SPARK_VERSION=2.3.4
ENV HADOOP_VERSION=2.7
ENV SCALA_VERSION=2.12.7
ENV SCALA_HOME=/usr/share/scala

# Install Java and some OS dependencies to monitor the container
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https ca-certificates \
    curl \
    pkg-config \
    wget \
    rsync \
    software-properties-common \
    unzip \
    logrotate \
    supervisor \
    net-tools \
    openjdk-8-jdk \
    && \
    apt-get clean

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Configure Supervisor to display web interface
RUN rm /etc/supervisor/supervisord.conf
ADD supervisor/supervisord.conf /etc/supervisor/

# Install Scala
RUN cd "/tmp" && \
    wget --no-verbose "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    rm -rf "/tmp/"*
    
# Install Sbt
RUN export PATH="/usr/local/sbt/bin:$PATH" &&  \
    mkdir -p "/usr/local/sbt" && wget -qO - --no-check-certificate "https://piccolo.link/sbt-1.2.8.tgz" | tar xz -C /usr/local/sbt --strip-components=1 && sbt sbtVersion

# Install Spark
RUN wget --no-verbose http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark \
      && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}
