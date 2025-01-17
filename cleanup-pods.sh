#!/bin/bash

for ERROR_TYPE in Evicted ContainerCreating CrashLoopBackOff Pending Error Terminating NodeAffinity Unknown Init:ContainerStatusUnknown;
do
  kubectl get pods --all-namespaces | grep ${ERROR_TYPE} | while read line; do
    pod_name=$(echo $line | awk '{print $2}' ) \
    name_space=$(echo $line | awk '{print $1}' ); \
    kubectl delete pods $pod_name -n $name_space --grace-period=0 --force
  done
done
