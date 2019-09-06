# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

include .env

.DEFAULT_GOAL=build

network:
	@docker network inspect $(DOCKER_NETWORK_NAME) >/dev/null 2>&1 || docker network create $(DOCKER_NETWORK_NAME)

volumes:
	@docker volume inspect $(DATA_VOLUME_HOST) >/dev/null 2>&1 || docker volume create --name $(DATA_VOLUME_HOST)
	@docker volume inspect $(DB_VOLUME_HOST) >/dev/null 2>&1 || docker volume create --name $(DB_VOLUME_HOST)
	@docker volume inspect $(DATA_VOLUME_NAMENODE) >/dev/null 2>&1 || docker volume create --name $(DATA_VOLUME_NAMENODE)
	@docker volume inspect $(DATA_VOLUME_DATANODE) >/dev/null 2>&1 || docker volume create --name $(DATA_VOLUME_DATANODE)

self-signed-cert:
	# make a self-signed cert

secrets/postgres.env:
	@echo "Generating postgres password in $@"
	@echo "POSTGRES_PASSWORD=$(shell openssl rand -hex 32)" > $@

secrets/oauth.env:
	@echo "Need oauth.env file in secrets with GitHub parameters"
	@exit 1

secrets/jupyterhub.crt:
	@echo "Need an SSL certificate in secrets/jupyterhub.crt"
	@exit 1

secrets/jupyterhub.key:
	@echo "Need an SSL key in secrets/jupyterhub.key"
	@exit 1

userlist:
	@echo "Add usernames, one per line, to ./userlist, such as:"
	@echo "    zoe admin"
	@echo "    wash"
	@exit 1

# Do not require cert/key files if SECRETS_VOLUME defined
secrets_volume = $(shell echo $(SECRETS_VOLUME))
ifeq ($(secrets_volume),)
	cert_files=$(SECRETS_DIR)/jupyterhub.crt $(SECRETS_DIR)/jupyterhub.key
else
	cert_files=
endif

check-files: $(USERLIST_PATH) $(cert_files) $(SECRETS_DIR)/oauth.env $(SECRETS_DIR)/postgres.env

pull:
	docker pull $(DOCKER_NOTEBOOK_IMAGE)

notebook_image:
	cd user_container && \
	docker-compose build

spark-base:
	cd spark-base && \
	docker-compose build

hadoop-base:
	cd hadoop-base && \
	docker-compose build

build: check-files network volumes
	docker-compose build

.PHONY: network volumes check-files pull notebook_image spark-base hadoop-base build
