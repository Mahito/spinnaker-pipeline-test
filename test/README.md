* edit test.sh

* generate manifest.yaml
```
cat <(echo ---) <(kubectl create namespace test --dry-run -o yaml) <(echo ---) <(kubectl create namespace test-svcerr --dry-run -o yaml) <(echo ---) <(kubectl -n test create configmap script --from-file test.sh --from-file check_response.sh --dry-run -o yaml) <(cat << '_EOF_'
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test
  namespace: test
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: test
  labels:
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: test
  namespace: test
_EOF_
) > manifest.yaml
```
