ARTIFACT_ID=k8s-minio
MAKEFILES_VERSION=10.2.1
VERSION=2025.6.13-2

.DEFAULT_GOAL:=help

include build/make/variables.mk
include build/make/clean.mk
include build/make/release.mk
include build/make/self-update.mk
include build/make/k8s-component.mk

BINARY_HELM_VERSION=v3.18.3

ADDITIONAL_CLEAN=clean_charts
clean_charts:
	rm -rf ${HELM_SOURCE_DIR}/charts

.PHONY: minio-release
minio-release: ## Interactively starts the release workflow for minio
	@echo "Starting git flow release..."
	@build/make/release.sh minio
