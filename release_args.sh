#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

componentTemplateFile=k8s/helm/component-patch-tpl.yaml
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
  minioRegistry=$(yq '.image.registry' < "${minioTempValues}")
  minioRepo=$(yq '.image.repository' < "${minioTempValues}")
  minioTag=$(yq '.image.tag' < "${minioTempValues}")
  setAttributeInComponentPatchTemplate ".values.images.minio" "${minioRegistry}/${minioRepo}:${minioTag}"

  local minioClientRegistry
  local minioClientRepo
  local minioClientTag
  minioClientRegistry=$(yq '.clientImage.registry' < "${minioTempValues}")
  minioClientRepo=$(yq '.clientImage.repository' < "${minioTempValues}")
  minioClientTag=$(yq '.clientImage.tag' < "${minioTempValues}")
  setAttributeInComponentPatchTemplate ".values.images.minio" "${minioClientRegistry}/${minioClientRepo}:${minioClientTag}"

  local minioOsShellRegistry
  local minioOsShellClientRepo
  local minioOsShellClientTag
  minioOsShellRegistry=$(yq '.volumePermissions.image.registry' < "${minioTempValues}")
  minioOsShellClientRepo=$(yq '.volumePermissions.image.repository' < "${minioTempValues}")
  minioOsShellClientTag=$(yq '.volumePermissions.image.tag' < "${minioTempValues}")
  setAttributeInComponentPatchTemplate ".values.images.minio" "${minioOsShellRegistry}/${minioOsShellClientRepo}:${minioOsShellClientTag}"

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
