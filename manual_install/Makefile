install:
	# Setup Kind k8s cluster
	kind create cluster --config argo_test_cluster.yml # Setup from manifest
	kubectl create namespace argocd # Create namespace for Argo CD
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml # Apply Argo CD from official source
	kubectl apply -f ../app/application.yml # Apply the Argo CD application

start:
	source ../maintenance/argo_cd_ui.sh # Run maintenance script to start

stop:
	pkill -f "port-forward" # Kill port forward running in background

clean:
	kind delete cluster --name argo-test # Remove the k8s cluster created
