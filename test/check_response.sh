#!/bin/bash

set -u

TARGET=$(kubectl get ingress -n $Namespace $Ingress -o go-template='{{ $ingress := index .status.loadBalancer.ingress 0 }}{{ $ingress.ip }}')

while : ; do
  echo "--- $(date +%Y%m%d-%H:%M:%S) ---"
  response=$(curl -i --header "HOST:$ProdFQDN" $TARGET 2> /dev/null)
  if [ $? -ne 0 ]; then
    echo "NG"
    exit 1
  elif [[ "$response" =~ "finish" ]]; then
    echo "OK"
    exit 0
  fi
  echo $response
  sleep .5
  echo
done

