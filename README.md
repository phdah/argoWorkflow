# argoWorkflow
Argo Workflow

## Installation

### Install for Kind, using Helm and Terraform
Following this [blog post](https://betterprogramming.pub/how-to-set-up-argo-cd-with-terraform-to-implement-pure-gitops-d5a1d797926a) and his [repo](https://github.com/bharatmicrosystems/argo-cd-example/blob/main/terraform/main.tf)

Using the present `main.tf` file to setup
* k8s cluster
* Argo CD, from [official manifest](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)
* Load a `application.yml` to initialize the CD

Run the following
```bash
cd terraform_helm
make install
```

##### Advantage
This method is less managed and allow for the latest version fo all services.

### Install for Kind, using Helm and Terraform
Following this [blog post](https://piotrminkowski.com/2022/06/28/manage-kubernetes-cluster-with-terraform-and-argo-cd/)

Using the present `main.tf` file to setup
* k8s cluster
* Argo CD, from Helm chart
* Load a `application.yml` to initialize the CD

Run the following
```bash
cd terraform_helm
make install
```

##### Disadvantage
This method requires *Argo CD* of version `<5.0.0`.

### Install for Minikube, without Terraform
Following [installation guide](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd)

Set up a Argo k8s cluster, then install Argo CD by
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Using and interacting with Argo CD

### Argo CD UI
Port forward the service to view the UI
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
The login is
```bash
admin # Username
kubectl get secrets argocd-initial-admin-secret -n argocd -o yaml | rg password | cut -d" " -f4 | base64 -d # Password
```

### Rolling back Argo CD
Since we have our CD application also automatically synced with git, when we ever make any changes, to either an application or Argo CD itself, we can just roll back with git. Use your knowledge of git to choose the appropriate way of doing so; `revert`, `reset`, `rebase`. Here is an example of how to do it with `reset` *to* a specific `COMMIT` id
```bash
git log --oneline
git reset --hard <COMMIT>
git push --force
```
