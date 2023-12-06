# k8s-minio betreiben

## Installation

`k8s-minio` kann als Komponente über den Komponenten-Operator des CES installiert werden.
Dazu muss eine entsprechende Custom-Resource (CR) für die Komponente erstellt werden.

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

Die neue yaml-Datei kann anschließend im Kubernetes-Cluster erstellt werden:

```shell
kubectl apply -f k8s-minio.yaml --namespace ecosystem
```

Der Komponenten-Operator erstellt nun die `k8s-minio`-Komponente im `ecosystem`-Namespace.

## Upgrade

Zum Upgrade muss die gewünschte Version in der Custom-Resource angegeben werden.
Dazu wird die erstellte CR yaml-Datei editiert und die gewünschte Version eingetragen.
Anschließend die editierte yaml Datei erneut auf den Cluster anwenden:

```shell
kubectl apply -f k8s-minio.yaml --namespace ecosystem
```

## Konfiguration

Die Komponente kann über das Feld `spec.valuesYamlOverwrite`. Die Konfigurationsmöglichkeiten entsprechen denen von
[Minio](https://min.io/docs/minio/kubernetes/openshift/reference/operator-chart-values.html).
Die Konfiguration für das Minio Helm-Chart muss in der `values.yaml` unter dem Key `minio` abgelegt werden.

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

### Zusätzliche Konfiguration

Neben der oben beschriebenen Standard-Konfiguration von Minio, verfügt die `k8s-minio`-Komponente über zusätzliche
Konfiguration:

| Parameter                    | Beschreibung                                                                                                                                | Default-Wert                     |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------|
| lokiServiceAccountSecretName | Der Name des K8S-Secrets, das erzeugt wird um Username und Passwort für den Minio-Bucket bereitzustellen, der von `k8s-loki` verwendet wird | `k8s-minio-service-account-loki` |

## Zugriff auf Minio-Oberfläche

Um die Minio-Oberfläche erreichen zu können, muss der Port 9001 vom Minio-Pod weitergeleitet werden.
Anschließend kann sich mit z.B. dem Root-User (Credentials im Secret `k8s-minio-root-user`) angemeldet werden.