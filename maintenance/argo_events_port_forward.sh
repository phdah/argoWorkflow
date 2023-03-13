#!/bin/bash

kubectl -n argo-events port-forward $(kubectl get pods -o name -l eventsource-name=webhook -n argo-events)  12000:12000 > /dev/null &
printf "\n\nEvent trigger\n\ncurl -X POST \\\\\n-H \"Content-Type: application/json\" \\\\\n-d '{\"message\":\"My first webhook\"}' \\\\\nhttp://localhost:12000/example && sleep 3 &&\nkubectl get pods -n argo-events --selector app=payload &&\nkubectl logs -n argo-events --selector app=payload\n"
printf "\nDelete all triggered pods\n\nkubectl --namespace argo-events delete pods --selector app=payload\n"
