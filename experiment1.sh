#!/bin/bash
echo "Starting setup for experiment 1..."

echo "Start TeaStore application..."
kubectl version --client

echo "Press any key to continue"
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
exit ;
else
echo "waiting for the keypress"
kubectl version --client
kubectl apply -f /controller/teastore/teastore-clusterip.yaml
fi
done
