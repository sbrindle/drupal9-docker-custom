REGISTRY_URL = custom
DEFAULT_TAG ?= latest
DEPENDENCY_TAG ?= latest

# Docker default commands.
.PHONY: login

login: ## Login to container registry (account can only pull images).
	#docker login $(REGISTRY_URL) --username="USER" --password="PASSWORD"

# Build docker images.
.PHONY: build build-clamav build-cron build-nginx build-php build-sass

# Be sure to build PHP image before CRON and NGINX images.
build: build-clamav build-php build-cron build-nginx build-sass ## Build all docker images.

build-clamav: # Build ClamAV docker image.
	docker build -t $(REGISTRY_URL)/clamav:$(DEFAULT_TAG) ./docker/clamav

build-cron: # Build CRON docker image.
	docker build -t $(REGISTRY_URL)/cron:$(DEFAULT_TAG) ./docker/cron \
		--build-arg DEFAULT_TAG=$(DEPENDENCY_TAG)

build-nginx: # Build NGINX docker image.
	docker build -t $(REGISTRY_URL)/nginx:$(DEFAULT_TAG) ./docker/nginx \
		--build-arg DEFAULT_TAG=$(DEPENDENCY_TAG)

build-php: # Build PHP docker image.
	docker build -t $(REGISTRY_URL)/php:$(DEFAULT_TAG) -f docker/php/Dockerfile .

build-sass: # Build Sass docker image.
	docker build -t $(REGISTRY_URL)/sass:$(DEFAULT_TAG) ./docker/sass

# Publish docker images.
.PHONY: publish-clamav publish-cron publish-nginx publish-php publish-sass

publish-clamav: # Publish ClamAV docker image.
	docker push $(REGISTRY_URL)/clamav:$(DEFAULT_TAG)

publish-cron: # Publish CRON docker image.
	docker push $(REGISTRY_URL)/cron:$(DEFAULT_TAG)

publish-nginx: # Publish NGINX docker image.
	docker push $(REGISTRY_URL)/nginx:$(DEFAULT_TAG)

publish-php: # Publish PHP docker image.
	docker push $(REGISTRY_URL)/php:$(DEFAULT_TAG)

publish-sass: # Publish Sass docker image.
	docker push $(REGISTRY_URL)/sass:$(DEFAULT_TAG)
