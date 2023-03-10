#!/bin/bash

echo "Port forwarding Argo CD UI: https://127.0.0.1:8080/"
kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null &
xdg-open https://127.0.0.1:8080/
printf "\nThe login is\n"
echo "Username: admin"
echo "Password: $(kubectl get secrets argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -d)"
