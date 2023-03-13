install:
	# Setup Kind k8s cluster
	kind create cluster --config argo_test_cluster.yml # Setup from manifest
	# Setup namespaces for Argo
	kubectl apply -f namespace.yml
	# Setup Argo CD
	kubectl apply -n argocd -f ../app/argo/argocd/argocd.yml # Apply Argo CD from official source
	kubectl apply -f ../app/application.yml # Apply the Argo CD application

start:
	source ../maintenance/argo_cd_ui.sh # Run maintenance script to start
	source ../maintenance/argo_workflow_ui.sh # Run maintenance script to start
	source ../maintenance/argo_events_port_forward.sh # Run maintenance script to start

stop:
	pkill -f "port-forward" # Kill port forward running in background

clean:
	kind delete cluster --name argo-test # Remove the k8s cluster created
