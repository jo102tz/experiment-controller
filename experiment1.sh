#!/bin/bash
echo "Starting setup for experiment 1..."

kubectl version --client

echo "Start TeaStore application..."
kubectl create -f /controller/teastore/teastore-clusterip.yaml
echo "Application up!"

echo "Start load generator slaves..."
kubectl create -f loadgenerator/loadgenerator-pod.yaml
echo "Generators up!"

echo "Setup complete!"

echo "Tearing down after 20 seconds.."
for i in {1..20}
do
echo "Waited for $i seconds..."
sleep 1
done

echo "Start clean up..."
kubectl delete -f /controller/teastore/teastore-clusterip.yaml
kubectl delete -f loadgenerator/loadgenerator-pod.yaml

echo "Clean up complete!"
echo "Finished!"

