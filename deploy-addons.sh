#!/bin/bash

for AO in $(find ./add-ons/ |sort ); 
  do
    if [[ "$AO" == *".yaml" ]]; then
      echo  "#### Deploying Add On: ${AO} ####";
      # ArgoCD is special
      if [[ "$AO" == *"argo-custom.yaml" ]]; then
        kubectl apply -n argocd -f ${AO};
      else
        kubectl apply -f ${AO};
      fi
    fi
  done