#!/bin/bash

for AO in $(find ./add-ons/ |sort ); 
  do
    [[ "$AO" == *".yaml" ]] && \
    echo  "#### Deploying Add On: ${AO} ####" &&  \
    kubectl apply -f ${AO};
  done