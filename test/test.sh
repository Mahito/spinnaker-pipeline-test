#!/bin/bash

EXIT_CODE=0

set -xu

function assert_equal (){
  local expect=$1
  local actual=$2
  if [ "$expect" = "$actual" ]; then
    echo ok
  else
    echo ng
    EXIT_CODE=1
  fi
}

: "test 1" ; true && {
  Actual_NumberOfRS=$(kubectl get rs -n $Namespace -o go-template='{{ len .items }}')
  assert_equal $Actual_NumberOfRS 1
}

: "test 2" ; true && {
  Actual_NumberOfPod=$(kubectl get rs -n $Namespace -o go-template='{{ $rs := index .items 0 }}{{ $rs.spec.replicas }}')
  assert_equal $Actual_NumberOfPod $Expect_NumberOfPod
}

: "test 3" ; true && {
  # MEMO: NG: kubectl get replicasets -n $Namespace -o go-template='{{ $rs := index .items 0 }}{{ $rs.metadata.annotations.artifact.spinnaker.io/version }}'
  Actual_PodVersion=$(kubectl get replicasets -n $Namespace -o go-template='{{ $rs := index .items 0 }}{{ $rs.metadata.name }}' | awk -F'-' '{ print $NF }')
  assert_equal $Expect_PodVersion $Actual_PodVersion
}

: "test 4" ; true && {
  TARGET=$(kubectl get ingress -n $Namespace $Ingress -o go-template='{{ $ingress := index .status.loadBalancer.ingress 0 }}{{ $ingress.ip }}')
  Actual_Response=$(curl --header "HOST:$ProdFQDN" $TARGET 2> /dev/null)
  assert_equal $Expect_Response $Actual_Response
}

exit $EXIT_CODE
