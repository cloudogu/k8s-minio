# k8s-minio betreiben

## Installation

`k8s-minio` kann als Komponente über den Komponenten-Operator des CES installiert werden.
Dazu muss eine entsprechende Custom-Resource (CR) für die Komponente erstellt werden.

```yaml
TODO
```

Die erstellte yaml-Datei kann anschließend im Kubernetes-Cluster erstellt werden:
```shell
kubectl apply -f k8s-minio.yaml --namespace ecosystem
```

Der Komponenten-Operator erstellt nun die `k8s-minio`-Komponente im `ecosystem`-Namespace.

## Upgrade

Zum Upgrade muss die gewünschte Version in der Custom-Resource angegeben werden.
Dazu wird die erstellte CR yaml-Datei editiert und die gewünschte Version eingetragen.

