#!/bin/bash

for EX in $(find ./examples/ |sort ); 
  do
    [[ "$EX" == *".yaml" ]] && \
    echo  "#### Deploying Add On: ${EX} ####" && \
    kubectl apply -f ${EX};
  done