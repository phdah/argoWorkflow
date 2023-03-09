install:
	# Terraform run
	terraform init
	terraform plan
	terraform apply

clean:
	terraform destroy # Destroy Terraform
	rm -rf terraform.* .terraform* # Remove all Terraform created files
	kind delete cluster --name argo-test # Remove the k8s cluster created
	rm argo-test-config # Remove the config file that "kind" creates
