ARTIFACT_ID=k8s-minio
MAKEFILES_VERSION=9.10.0
VERSION=2024.11.7-3

.DEFAULT_GOAL:=help

include build/make/variables.mk
include build/make/clean.mk
include build/make/release.mk
include build/make/self-update.mk
include build/make/k8s-component.mk

ADDITIONAL_CLEAN=clean_charts
clean_charts:
	rm -rf ${HELM_SOURCE_DIR}/charts

.PHONY: minio-release
minio-release: ## Interactively starts the release workflow for minio
	@echo "Starting git flow release..."
	@build/make/release.sh minio
