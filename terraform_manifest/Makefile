install:
	# Terraform run
	terraform init
	terraform plan
	terraform apply

start:
	source ../maintenance/argo_cd_ui.sh # Run maintenance script to start
	source ../maintenance/argo_workflow_ui.sh # Run maintenance script to start
	source ../maintenance/argo_events_port_forward.sh # Run maintenance script to start

stop:
	pkill -f "port-forward" # Kill port forward running in background

clean:
	terraform destroy # Destroy Terraform
	rm -rf terraform.* .terraform* # Remove all Terraform created files
	kind delete cluster --name argo-test # Remove the k8s cluster created
	rm argo-test-config # Remove the config file that "kind" creates
