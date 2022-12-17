
DOCKER = docker

IMAGE_BUILT = alpine-squid
IMAGE_CI_TOOLKIT = jfxs/ci-toolkit
IMAGE_FROM_REPOSITORY = library/alpine
IMAGE_FROM_TAG = latest

## Docker
## ------
docker-build-push: ## Build docker image. Arguments: user=dockerhubUser password=dockerhubPassword [arch=arm64] [vcs_ref=c780b3a] [tag=myTag]
docker-build-push:
	test -n "${user}"  # Failed if user not set
	test -n "${password}"  # Failed if password not set
	$(eval arch := $(shell if [ -z ${arch} ]; then echo "amd64"; else echo "${arch}"; fi))
	$(eval sha_tag := $(shell if [ -z ${container} ]; then \
		docker run -t ${IMAGE_CI_TOOLKIT} /bin/sh -c "get-identical-tag.sh -r ${IMAGE_FROM_REPOSITORY} -u ${user} -p ${password} -t ${IMAGE_FROM_TAG} -a ${arch} -x '\([0-9]*\.[0-9]*\.[0-9]*\)'"; \
	else \
		get-identical-tag.sh -r ${IMAGE_FROM_REPOSITORY} -u ${user} -p ${password} -t ${IMAGE_FROM_TAG} -a ${arch} -x "\([0-9]*\.[0-9]*\.[0-9]*\)"; \
	fi))
	@echo ${sha_tag}
	$(eval latest_sha := $(shell echo ${sha_tag} | awk '{print $$1}'))
	$(eval version := $(shell docker run -it --rm alpine@${latest_sha} /bin/sh -c "apk --no-cache add squid" | grep "Installing squid" | sed 's/.*(\(.*\)-.*)/\1/'))
	$(eval version := $(shell if [ ${#version} -lt 5 ]; then echo "${version}.0"; else echo "${version}"; fi))
	$(eval tag := $(shell if [ -z ${tag} ]; then echo "${IMAGE_BUILT}:latest"; else echo "${tag}"; fi))
	$(eval build_date := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ'))
	if [ "${arch}" = "arm64" ]; then \
		docker buildx build --progress plain --no-cache --platform linux/arm64 --build-arg IMAGE_FROM_SHA="alpine@${latest_sha}" --build-arg SQUID_VERSION=${version} --build-arg VCS_REF=${vcs_ref} --build-arg BUILD_DATE=${build_date} -t ${tag} --push . && \
		docker pull ${tag}; \
	else \
		docker build --no-cache --build-arg IMAGE_FROM_SHA="alpine@${latest_sha}" --build-arg SQUID_VERSION=${version} --build-arg VCS_REF=${vcs_ref} --build-arg BUILD_DATE=${build_date} -t ${tag} . && \
		docker push ${tag}; \
	fi

dockerhub-tag: ## Tag image on Dockerhub. Arguments: init-image-tag publish-image publish-tag
dockerhub-tag:
	test -n "${init-image-tag}"  # Failed if init-image-tag not set
	test -n "${publish-image}"  # Failed if publish-image not set
	test -n "${publish-tag}"  # Failed if publish-tag not set
	$(DOCKER) pull ${init-image-tag}
	$(DOCKER) tag ${init-image-tag} ${publish-image}:${publish-tag}
	$(DOCKER) push ${publish-image}:${publish-tag}
	$(DOCKER) tag ${init-image-tag} ${publish-image}:latest
	$(DOCKER) push ${publish-image}:latest

PHONY: docker-build-push dockerhub-tag

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help
