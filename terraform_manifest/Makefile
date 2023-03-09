install:
	# Fetch the latest Argo CD install
	curl https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml > ${HOME}/repos/privat/argoWorkflow/app/argocd.yml
	# Terraform run
	terraform init
	terraform plan
	terraform apply

clean:
	terraform destroy # Destroy Terraform
	rm -rf terraform.* .terraform* # Remove all Terraform created files
	kind delete cluster --name argo-test # Remove the k8s cluster created
	rm argo-test-config # Remove the config file that "kind" creates
