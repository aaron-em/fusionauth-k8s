#!/bin/bash

echo "  🛑                        BE WARNED:                        🛑"
echo "  🛑 This will delete your database, too,  including its PVC! 🛑"
echo "  🛑         Ensure you have a backup if you want one         🛑"
echo "  🛑             ^C to abort,  Return to continue             🛑"
read

helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null
helm repo add elastic https://helm.elastic.co 2>/dev/null
helm repo add fusionauth https://fusionauth.github.io/charts 2>/dev/null

helm --namespace fusionauth list | tail -n +2 | awk '{print $1}' | \
    xargs helm --namespace fusionauth uninstall

# namespace-scoped resources are dropped along with the namespace
kubectl delete --ignore-not-found -f storage-class.yaml
kubectl delete --ignore-not-found -f namespace.yaml
