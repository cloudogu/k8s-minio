ARTIFACT_ID=k8s-minio
MAKEFILES_VERSION=8.4.0
VERSION=2023.9.23-2

.DEFAULT_GOAL:=help

ADDITIONAL_CLEAN=clean_charts
clean_charts:
	rm -rf ${K8S_HELM_RESSOURCES}/charts


include build/make/variables.mk
include build/make/clean.mk
include build/make/release.mk
include build/make/self-update.mk

##@ Release

K8S_PRE_GENERATE_TARGETS=generate-release-resource
include build/make/k8s-component.mk

.PHONY: generate-release-resource
generate-release-resource: $(K8S_RESOURCE_TEMP_FOLDER)
	@cp manifests/minio.yaml ${K8S_RESOURCE_TEMP_YAML}

.PHONY: minio-release
minio-release: ## Interactively starts the release workflow for minio
	@echo "Starting git flow release..."
	@build/make/release.sh minio

##@ Helm dev targets
# MinIO needs a copy of the targets from k8s.mk without image-import because we use an external image here.

.PHONY: ${K8S_HELM_RESSOURCES}/charts
${K8S_HELM_RESSOURCES}/charts: ${BINARY_HELM}
	@cd ${K8S_HELM_RESSOURCES} && ${BINARY_HELM} repo add bitnami https://charts.bitnami.com/bitnami && ${BINARY_HELM} dependency build

.PHONY: helm-minio-apply
helm-minio-apply: ${BINARY_HELM} ${K8S_HELM_RESSOURCES}/charts helm-generate $(K8S_POST_GENERATE_TARGETS) ## Generates and installs the helm chart.
	@echo "Apply generated helm chart"
	@${BINARY_HELM} upgrade -i ${ARTIFACT_ID} ${K8S_HELM_TARGET} --namespace ${NAMESPACE}

.PHONY: helm-minio-reinstall
helm-minio-reinstall: helm-delete helm-minio-apply ## Uninstalls the current helm chart and reinstalls it.

.PHONY: helm-minio-chart-import
helm-minio-chart-import: ${BINARY_HELM} ${K8S_HELM_RESSOURCES}/charts k8s-generate helm-generate-chart helm-package-release ## Pushes the helm chart to the k3ces registry.
	@if [[ ${STAGE} == "development" ]]; then \
		echo "Import ${K8S_HELM_DEV_RELEASE_TGZ} into K8s cluster ${K3CES_REGISTRY_URL_PREFIX}..."; \
		${BINARY_HELM} push ${K8S_HELM_DEV_RELEASE_TGZ} oci://${K3CES_REGISTRY_URL_PREFIX}/${K8S_HELM_ARTIFACT_NAMESPACE} ${BINARY_HELM_ADDITIONAL_PUSH_ARGS}; \
	else \
        echo "Import ${K8S_HELM_RELEASE_TGZ} into K8s cluster ${K3CES_REGISTRY_URL_PREFIX}..." \
		${BINARY_HELM} push ${K8S_HELM_RELEASE_TGZ} oci://${K3CES_REGISTRY_URL_PREFIX}/${K8S_HELM_ARTIFACT_NAMESPACE} ${BINARY_HELM_ADDITIONAL_PUSH_ARGS}; \
    fi
	@echo "Done."

.PHONY: component-minio-apply
component-minio-apply: ${BINARY_HELM} check-k8s-namespace-env-var ${K8S_HELM_RESSOURCES}/charts helm-minio-chart-import component-generate $(K8S_POST_GENERATE_TARGETS) ## Applies the component yaml resource to the actual defined context.
	@kubectl apply -f "${K8S_RESOURCE_COMPONENT}" --namespace="${NAMESPACE}"
	@echo "Done."