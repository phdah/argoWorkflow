# argoWorkflow
Fully automated setup for local functioning [Argo CI/CD](https://argoproj.github.io/). It is done by
* setting up [Kind](https://kind.sigs.k8s.io/) k8s cluster
* installing Argo CD

Then Argo CD installs and maintain all other applications specified in the `app/application.yml` file. Here both other infra apps, such as Argo itself, and non-infra apps are defined.

Everything is setup to be done with `make` for an easy and idempotent interaction.

#### Useful links
Argo Workflow: [installation guide](https://argoproj.github.io/argo-workflows/quick-start/)
Argo Events [working example](https://gist.github.com/vfarcic/a0a7ff04a7e22409cdfd8b466edb4e48)

## Installation

### Install for Kind, using manifest files and Terraform
Following this [blog post](https://betterprogramming.pub/how-to-set-up-argo-cd-with-terraform-to-implement-pure-gitops-d5a1d797926a) and his [repo](https://github.com/bharatmicrosystems/argo-cd-example/blob/main/terraform/main.tf)

Using the present `main.tf` file to setup
* k8s cluster
* Argo CD, from [official manifest](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)
* Load a `application.yml` to initialize the CD

Run the following
```bash
cd terraform_manifest
make install
```

### Install for Kind, without Terraform
Following [installation guide](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd)

Using the present manifest files
* k8s cluster
* Argo CD, from [official manifest](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)
* Load a `application.yml` to initialize the CD

Run the following
```bash
cd manual_install
make install
```

## Using and interacting with Argo

### Argo CI/CD UI
Once the pods are up and running, port forward the Argo services and fetch admin credentials to access the UI. There is a UI for both `Argo CD` and `Argo Workflows`.

Run the following to start services
```bash
make start
```
To stop the services, run
```bash
make stop
```

If the UI's don't auto start, you will find Argo CD on https://localhost:8080/, and Argo Workflow on https://localhost:2746/. All the commands are placed in the `maintenance` directories as shell scripts.

### Rolling back Argo CD
Since we have our CD application also automatically synced with git, when we ever make any changes, to either an application or Argo CD itself, we can just roll back with git. Use your knowledge of git to choose the appropriate way of doing so; `revert`, `reset`, `rebase`. Here is an example of how to do it with `reset` *to* a specific `COMMIT` id
```bash
git log --oneline
git reset --hard <COMMIT>
git push --force
```

## Clean up
To clean up the k8s cluster and all created resources and files, just run
```bash
make clean
```
inside of the chosen installation method's directory.

## *Our* Argo Architecture
Applications are continuously deployed with Argo CD. The applications are deployed using a GitOps structure, where the *actual state* is compared to the *desired state* to identify the need for updating the k8s resources.

The Argo infra is using a automatic sync approach, i.e., sync every three minutes while all deployed applications use the EventFlow structure. These apps are deployed using Workflows. These are tightly coupled with Events, using the below architecture.

<img src="https://argoproj.github.io/argo-events/assets/argo-events-architecture.png" alt="" style="height: 200px; width: auto;"/>

Events are written to the Event Bus, which are then picked up by the Sensor which triggers the Workflow and does potential tests etc, and finished by deploying to prod env.
