ARTIFACT_ID=k8s-minio
MAKEFILES_VERSION=9.3.2
VERSION=2023.9.23-7

.DEFAULT_GOAL:=help

ADDITIONAL_CLEAN=clean_charts
clean_charts:
	rm -rf ${K8S_HELM_RESSOURCES}/charts

include build/make/variables.mk
include build/make/clean.mk
include build/make/release.mk
include build/make/self-update.mk
include build/make/k8s-component.mk

.PHONY: minio-release
minio-release: ## Interactively starts the release workflow for minio
	@echo "Starting git flow release..."
	@build/make/release.sh minio
