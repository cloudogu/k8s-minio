# operate k8s-minio

## Installation

`k8s-minio` can be installed as a component via the CES component operator.
To do this, a corresponding custom resource (CR) must be created for the component.

```yaml
apiVersion: k8s.cloudogu.com/v1
kind: Component
metadata:
  name: k8s-minio
  labels:
    app: ces
spec:
  name: k8s-minio
  namespace: k8s
  version: 2023.9.23-2
```

The new yaml file can then be created in the Kubernetes cluster:

```shell
kubectl apply -f k8s-minio.yaml --namespace ecosystem
```

The component operator now creates the `k8s-minio` component in the `ecosystem` namespace.

## Upgrade

To upgrade, the desired version must be specified in the custom resource.
To do this, the CR yaml file created is edited and the desired version is entered.
Then apply the edited yaml file to the cluster again:

```shell
kubectl apply -f k8s-minio.yaml --namespace ecosystem
```

## Configuration

The component can be overwritten via the `spec.valuesYamlOverwrite` field. The configuration options correspond to those
of
[Minio](https://min.io/docs/minio/kubernetes/openshift/reference/operator-chart-values.html).
The configuration for the Minio Helm chart must be stored in `values.yaml` under the key `minio`.

**Beispiel:**

```yaml
apiVersion: k8s.cloudogu.com/v1
kind: Component
metadata:
  name: k8s-minio
  labels:
    app: ces
spec:
  name: k8s-minio
  namespace: k8s
  version: 2023.9.23-2
  valuesYamlOverwrite: |
    minio:
      persistence:
        size: 1Gi
```

### Additional configuration

In addition to the standard Minio configuration described above, the `k8s-minio` component has additional configuration:

| Parameters                   | Description                                                                                                                | Default-Value                    |
|------------------------------|----------------------------------------------------------------------------------------------------------------------------|----------------------------------|
| lokiServiceAccountSecretName | The name of the K8S secret that is generated to provide the username and password for the Minio bucket used by `k8s-loki`. | `k8s-minio-service-account-loki` |

## Access to Minio user interface

In order to access the Minio user interface, port 9001 must be forwarded from the Minio pod.
You can then log in using, for example, the root user (credentials in the secret `k8s-minio-root-user`).