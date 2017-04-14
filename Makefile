.PHONY: all build test run bash tag push pull help kill clean
.DEFAULT_GOAL := help

NAME = project-x
NAMESPACE = barcelonapm
RELEASE_VERSION ?= latest
LOCAL_IMAGE := $(NAME):$(RELEASE_VERSION)
REMOTE_IMAGE := $(NAMESPACE)/$(LOCAL_IMAGE)

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
THISDIR_PATH := $(patsubst %/,%,$(abspath $(dir $(MKFILE_PATH))))
PROJECT_PATH := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

all: build

update: build push

build: ## Build docker image with name LOCAL_IMAGE (NAME:RELEASE_VERSION).
	docker build -f $(THISDIR_PATH)/Dockerfile -t $(LOCAL_IMAGE) $(PROJECT_PATH)

test: ## Test built LOCAL_IMAGE (NAME:RELEASE_VERSION).
	docker-compose run --rm -u 1001 --entrypoint=carton mojo exec prove -lv

run_image: ## Run the Application Docker image in the local machine.
	docker-compose run --rm -u 1001 --name mojo -i -t -p 8080:8080 $(LOCAL_IMAGE)

run: ## Run the Application Docker Compose in the local machine.
	docker-compose up 

kill: ## Kill the docker in the local machine.
	docker kill $(RELEASE_VERSION)

bash: ## Start bash in the build IMAGE_NAME.
	docker run --rm --entrypoint=/bin/bash -it $(LOCAL_IMAGE)

tag: ## Tag IMAGE_NAME
	docker tag $(LOCAL_IMAGE) $(REMOTE_IMAGE)

push: tag ## Push to the docker registry
	docker push $(REMOTE_IMAGE)

pull: ## Pull the docker from the Registry
	docker pull $(REMOTE_IMAGE)

clean: ## Clean local images from this build.
	docker rmi $(LOCAL_IMAGE) --force
	rm -rf ./compose/pgdata

# Check http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
