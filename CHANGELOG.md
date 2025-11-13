# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- [#22] Use `alpine/kubectl` instead of `bitnamilegacy/kubectl` to reduce the number of critical CVEs.

## [v2025.6.13-2] - 2025-08-25
### Changed
- [#20] Use "bitnamilegacy"-images for MinIO 

## [v2025.6.13-1] - 2025-07-10
### Changed
- [#18] Update chart to 17.0.8 and therefore MinIO to 2025.6.13
- Update Makefiles to v10.1.1

## [v2024.11.7-3] - 2025-04-24
### Changed
- [#16] Set sensible resource requests and limits

## [v2024.11.7-2] - 2024-12-10
### Added
- [#14] NetworkPolicy to block all ingress traffic
  - Dependent Dogus and Components must bring their own NetworkPolicy to access MinIO
### Removed
- [#14] Official NetworkPolicies in the MinIO chart have been disabled as ours are more restrictive for ingress.

## [v2024.11.7-1] - 2024-11-27
### Changed
- Update chart to 14.8.5 and therefore MinIO to 2024.11.7
- [#12] Deactivate unused service account token mount

## [v2023.9.23-7] - 2024-10-28
### Changed
- [#10] Use `ces-container-registries` secret for pulling container images as default.

## [v2023.9.23-6] - 2024-09-19
### Changed
- [#8] Relicense to AGPL-3.0-only

## [v2023.9.23-5] - 2023-12-13
### Fixed
- [#6] Add missing key in patch templates.

## [v2023.9.23-4] - 2023-12-06

## [v2023.9.23-3] - 2023-12-06
### Added
- [#2] Add patch templates for using the chart in airgapped environments.
- [#4] Add default configuration and secrets for provisioning a user and bucket for k8s-loki 

## [v2023.9.23-2] - 2023-09-27
### Fixed
- Fix release to helm-registry

## [v2023.9.23-1] - 2023-09-27
- initial release
