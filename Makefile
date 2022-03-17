include docker.mk

default: build

## Linter commands
.PHONY: lint lint-docker

lint: lint-docker # Run all linters.

lint-docker: # Lint docker images.
	docker pull hadolint/hadolint
	docker run --rm -i -v ${PWD}/.hadolint.yml:/.config/hadolint.yaml hadolint/hadolint < docker/clamav/Dockerfile
	docker run --rm -i -v ${PWD}/.hadolint.yml:/.config/hadolint.yaml hadolint/hadolint < docker/cron/Dockerfile
	docker run --rm -i -v ${PWD}/.hadolint.yml:/.config/hadolint.yaml hadolint/hadolint < docker/nginx/Dockerfile
	docker run --rm -i -v ${PWD}/.hadolint.yml:/.config/hadolint.yaml hadolint/hadolint < docker/php/Dockerfile
	docker run --rm -i -v ${PWD}/.hadolint.yml:/.config/hadolint.yaml hadolint/hadolint < docker/sass/Dockerfile
