#!/bin/bash
echo "Starting setup for experiment 1..."

echo "Start TeaStore application..."
kubectl version --client
kubectl apply -f /controller/teastore/teastore-clusterip.yaml

echo "Press any key to continue"
