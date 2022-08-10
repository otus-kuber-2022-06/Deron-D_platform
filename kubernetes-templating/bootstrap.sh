#!/bin/bash

kubectl create ns nginx-ingress

# helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx --wait \
# --namespace=nginx-ingress
helm upgrade --install nginx-ingress stable/nginx-ingress --wait \
 --namespace=nginx-ingress \
 --version=1.41.3


#Install CustomResourceDefinitions
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.1 \
  --set prometheus.enabled=false \
  --set webhook.timeoutSeconds=4

kubectl --namespace nginx-ingress get services -o wide

kubectl create ns chartmuseum

kubectl apply -f cert-manager/acme-issuer.yaml

helm upgrade --install chartmuseum stable/chartmuseum --wait \
 --namespace=chartmuseum \
 --version=2.13.2 \
 -f chartmuseum/values.yaml

#helm uninstall chartmuseum --namespace=chartmuseum

kubectl get secrets -n chartmuseum
