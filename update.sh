#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null
helm repo add elastic https://helm.elastic.co 2>/dev/null
helm repo add fusionauth https://fusionauth.github.io/charts 2>/dev/null

helm upgrade fusionauth --namespace fusionauth \
     -f config/fusionauth.yaml \
     fusionauth/fusionauth
