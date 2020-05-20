REPOSITORY_URI     := $(REPOSITORY)/ecnavi-sandbox-common-ec2-base
IMAGE_TAG          := latest
IMAGE_NAME         := amazonlinux_systemd:$(IMAGE_TAG)
CONTAINER_NAME     := provisioning-develop

DOCKER_CMD         := docker
DOCKER_COMPOSE_CMD := docker-compose
CMD                := /bin/bash --login
CACHE_DIR          := /tmp/docker-cache
HOST               := provioning.jp

.PHONY: $(shell echo docker/{login,pull,setup,run,graceful-stop,rm,clean,save,load})

docker/pull:
	$(DOCKER_COMPOSE_CMD) up --build -d
	$(DOCKER_CMD) commit amazonlinux_systemd $(IMAGE_NAME)

docker/setup: docker/pull

docker/run: docker/rm ## (docker) CMD を指定して走らせる
	$(DOCKER_CMD) run -d --privileged --name $(CONTAINER_NAME) \
	-v ${PWD}:/root/provisioning \
	-h $(HOST) -w /root/provisioning $(IMAGE_NAME) /sbin/init
	$(DOCKER_CMD) exec -it $(CONTAINER_NAME) $(CMD)
	$(MAKE) docker/rm

docker/exec:
	$(DOCKER_CMD) exec -it $(CONTAINER_NAME) $(CMD)

docker/rm: ## (docker) コンテナを強制削除する。
	[ ! `$(DOCKER_CMD) ps -q -a --filter name=$(CONTAINER_NAME)` ] || $(DOCKER_CMD) rm --force `$(DOCKER_CMD) ps -q -a --filter name=$(CONTAINER_NAME)` || true

docker/clean: ## (docker) イメージを削除する(local)
	$(DOCKER_CMD) rmi $(IMAGE_NAME)
