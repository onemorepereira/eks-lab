#!/bin/bash

# Non system namespace cleaner
NAMESPACES=$(kubectl get ns |grep -v NAME |grep -v kube-system |awk '{print $1}')

for NAMESPACE in ${NAMESPACES};
  do
    echo "# Checking namespace ${NAMESPACE}."

    echo "## Checking for ingress objects."
    INGRESSS=$(kubectl get ingress -n ${NAMESPACE} |grep -v NAME |awk '{print $1}')
    for INGRESS in ${INGRESSS};
      do
        echo "Cleaning up ingress ${INGRESS} from ${NAMESPACE}."
        kubectl delete ingress ${INGRESS} -n ${NAMESPACE}
      done

    echo "## Checking for service objects."
    SERVICES=$(kubectl get service -n ${NAMESPACE} |grep -v NAME |awk '{print $1}')
    for SERVICE in ${SERVICES};
      do
        echo "Cleaning up service ${SERVICE} from ${NAMESPACE}."
        kubectl delete service ${SERVICE} -n ${NAMESPACE}
      done

    echo "## Checking for deployment objects."
    DEPLOYMENTS=$(kubectl get deployments -n ${NAMESPACE} |grep -v NAME |awk '{print $1}')
    for DEPLOYMENT in ${DEPLOYMENTS};
      do
        echo "Cleaning up deployment ${DEPLOYMENT} from ${NAMESPACE}."
        kubectl delete deployment ${DEPLOYMENT} -n ${NAMESPACE}
      done
  done