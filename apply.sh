#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null
helm repo add elastic https://helm.elastic.co 2>/dev/null
helm repo add fusionauth https://fusionauth.github.io/charts 2>/dev/null
helm repo add jetstack https://charts.jetstack.io

# these are cluster-scoped, but would otherwise take a --namespace arg
kubectl apply -f namespace.yaml
kubectl apply -f storage-class.yaml

kubectl apply --namespace=fusionauth -f secret/postgres.yaml
kubectl apply --namespace=fusionauth -f secret/fusionauth.yaml
# kubectl apply --namespace=fusionauth -f secret/elasticsearch.yaml
kubectl apply --namespace=fusionauth -f letsencrypt-issuer.yaml
kubectl apply --namespace=fusionauth -f ingress.yaml

helm install pg --namespace fusionauth \
     -f config/postgres.yaml \
     bitnami/postgresql

# if you have the resources to run es:
# 1. in config/fusionauth.yaml set search.engine to 'elasticsearch'
#    and uncomment the relevant config entries there
# 2. uncomment the command below

# helm install es --namespace fusionauth \
#      -f config/elasticsearch.yaml \
#      elastic/elasticsearch

helm install fusionauth --namespace fusionauth \
     -f config/fusionauth.yaml \
     fusionauth/fusionauth

helm install cert-manager --namespace fusionauth \
     jetstack/cert-manager \
     --set installCRDs=true
