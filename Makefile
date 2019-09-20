# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

include .env

.DEFAULT_GOAL=build

network:
	@docker network inspect $(DOCKER_NETWORK_NAME) >/dev/null 2>&1 || docker network create $(DOCKER_NETWORK_NAME)

pull:
	docker pull $(DOCKER_NOTEBOOK_IMAGE)

spark-base:
	cd spark-base && \
	docker-compose build

hadoop-base:
	cd hadoop-base && \
	docker-compose build

build: network spark-base hadoop-base
	docker-compose build

.PHONY: network pull spark-base hadoop-base build
