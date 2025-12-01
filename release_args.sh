#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

componentTemplateFile=k8s/helm/component-patch-tpl.yaml
valuesFile=k8s/helm/values.yaml
minioTempChart="/tmp/minio"
minioTempValues="${minioTempChart}/values.yaml"

# this function will be sourced from release.sh and be called from release_functions.sh
update_versions_modify_files() {
  echo "Update helm dependencies"
  make helm-update-dependencies  > /dev/null

  # Extract cert-manager chart
  local minioVersion
  minioVersion=$(yq '.dependencies[] | select(.name=="minio").version' < "k8s/helm/Chart.yaml")
  local minioPackage
  minioPackage="k8s/helm/charts/minio-${minioVersion}.tgz"

  echo "Extract minio helm chart"
  tar -zxvf "${minioPackage}" -C "/tmp" > /dev/null

  echo "Set images in component patch template"

  local minioRegistry
  local minioRepo
  local minioTag
  minioRegistry=$(yq '.minio.image.registry' < "${valuesFile}")
  minioRepo=$(yq '.minio.image.repository' < "${valuesFile}")
  minioTag=$(yq '.minio.image.tag' < "${valuesFile}")
  setAttributeInComponentPatchTemplate ".values.images.minio" "${minioRegistry}/${minioRepo}:${minioTag}"

  local minioClientRegistry
  local minioClientRepo
  local minioClientTag
  minioClientRegistry=$(yq '.minio.clientImage.registry' < "${valuesFile}")
  minioClientRepo=$(yq '.minio.clientImage.repository' < "${valuesFile}")
  minioClientTag=$(yq '.minio.clientImage.tag' < "${valuesFile}")
  setAttributeInComponentPatchTemplate ".values.images.client" "${minioClientRegistry}/${minioClientRepo}:${minioClientTag}"

  local minioOsShellRegistry
  local minioOsShellClientRepo
  local minioOsShellClientTag
  minioOsShellRegistry=$(yq '.minio.defaultInitContainers.volumePermissions.image.registry' < "${valuesFile}")
  minioOsShellClientRepo=$(yq '.minio.defaultInitContainers.volumePermissions.image.repository' < "${valuesFile}")
  minioOsShellClientTag=$(yq '.minio.defaultInitContainers.volumePermissions.image.tag' < "${valuesFile}")
  setAttributeInComponentPatchTemplate ".values.images.osShell" "${minioOsShellRegistry}/${minioOsShellClientRepo}:${minioOsShellClientTag}"

  local minioConsoleRegistry
  local minioConsoleClientRepo
  local minioConsoleClientTag
  minioConsoleRegistry=$(yq '.minio.console.image.registry' < "${valuesFile}")
  minioConsoleClientRepo=$(yq '.minio.console.image.repository' < "${valuesFile}")
  minioConsoleClientTag=$(yq '.minio.console.image.tag' < "${valuesFile}")
  setAttributeInComponentPatchTemplate ".values.images.console" "${minioConsoleRegistry}/${minioConsoleClientRepo}:${minioConsoleClientTag}"

  local kubectlRegistry
  local kubectlClientRepo
  local kubectlClientTag
  kubectlRegistry=$(yq '.upgradeContainer.kubectl.image.registry' < "${valuesFile}")
  kubectlClientRepo=$(yq '.upgradeContainer.kubectl.image.repository' < "${valuesFile}")
  kubectlClientTag=$(yq '.upgradeContainer.kubectl.image.tag' < "${valuesFile}")
  setAttributeInComponentPatchTemplate ".values.images.kubectl" "${kubectlRegistry}/${kubectlClientRepo}:${kubectlClientTag}"

  rm -rf ${minioTempChart}
}

setAttributeInComponentPatchTemplate() {
  local key="${1}"
  local value="${2}"

  yq -i "${key} = \"${value}\"" "${componentTemplateFile}"
}

update_versions_stage_modified_files() {
  git add "${componentTemplateFile}"
}
