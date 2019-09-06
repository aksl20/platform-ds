# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG JUPYTERHUB_VERSION
FROM jupyterhub/jupyterhub-onbuild:$JUPYTERHUB_VERSION

# ENV http_proxy http://10.8.3.69:8080
# ENV https_proxy http://10.8.3.69:8080
ENV NO_PROXY localhost,172.19.0.3,127.0.0.1,172.17.0.1
ENV no_proxy localhost,172.19.0.3,127.0.0.1,172.17.0.1,jupyterhub

# Update and install some package
RUN apt-get update && apt-get install -yq --no-install-recommends \
	zsh \
        supervisor \
        logrotate \
	vim \
	git \
        make \
        nodejs \
        npm \
        pandoc \
        sqlite3 \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && hash -r
RUN conda update --all

# Configure Supervisor to display web interface
RUN rm /etc/supervisor/supervisord.conf
ADD supervisor/supervisord.conf /etc/supervisor/

# Install dockerspawner, oauth, postgres
RUN /opt/conda/bin/conda install -y psycopg2=2.7 && \
    /opt/conda/bin/conda clean -tipsy && \
    /opt/conda/bin/pip install --no-cache-dir \
        oauthenticator==0.7.* \
        dockerspawner==0.9.*

# Copy TLS certificate and key
ENV SSL_CERT /srv/jupyterhub/secrets/jupyterhub.crt
ENV SSL_KEY /srv/jupyterhub/secrets/jupyterhub.key
COPY ./secrets/*.crt $SSL_CERT
COPY ./secrets/*.key $SSL_KEY
RUN chmod 700 /srv/jupyterhub/secrets && \
    chmod 600 /srv/jupyterhub/secrets/*

COPY ./userlist /srv/jupyterhub/userlist

# python requirements
RUN /opt/conda/bin/conda install -y -c conda-forge elasticsearch \
		jupyter_client \
                jupyterlab \
		markdown \
		newrelic!=2.80.0.60 \
		nbformat>=4.2 \
		nbconvert>=5.2.1 \
		ipython \
		pycurl \
		pylibmc \
		tornado \
		statsd \
		invoke

WORKDIR /srv/jupyterhub

ENV JUPYTERHUB_LOG /var/log/jupyterhub

# Put Spark under supervision
RUN mkdir -p ${JUPYTERHUB_LOG}
ADD supervisor/jupyterhub.conf /etc/supervisor/conf.d/

CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
