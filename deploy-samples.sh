#!/bin/bash

for EX in $(find ./kubernetes/ |sort ); 
  do
    [[ "$EX" == *".yaml" ]] && \
    echo  "#### Deploying: ${EX} ####" && \
    kubectl apply -f ${EX};
  done