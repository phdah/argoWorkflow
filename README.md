# argoWorkflow
Argo Workflow

## Install
Following [installation guide](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd)

Set up a Argo k8s cluster, then install Argo CD by
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
Port forward the service to view the UI
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
The login is
```bash
User: admin
Password: $ kubectl get secrets argocd-initial-admin-secret -n argocd -o yaml | rg password | cut -d" " -f4 | base64 -d
```

## Rolling back Argo CD
Since we have our CD application also automatically synced with git, when we ever make any changes, to either an application or Argo CD itself, we can just roll back with git. Use your knowledge of git to choose the appropriate way of doing so; `revert`, `reset`, `rebase`. Here is an example of how to do it with `reset` *to* a specific `COMMIT` id
```bash
git log --oneline
git reset --hard <COMMIT>
git push --force
```
