#!/bin/bash
echo "Starting setup for experiment 3..."

kubectl version --client

echo "Start load generator slaves..."
kubectl create -f /controller/loadgenerator/loadgenerator-slave-1.yaml
echo "Generators up!"

echo "Setup complete!"

echo "Tearing down after 20 seconds.."
for i in {1..3}
do
echo "Waited for $i seconds..."
sleep 1
done

nslookup loadgenerator-slave-1
nslookup ts-ui-dashboard

java -jar /controller/httploadgenerator.jar loadgenerator & 


java -jar /controller/httploadgenerator.jar director --ip loadgenerator-slave-1 --load /controller/trainticket/loads/periodic_workload.csv -o exp2-slave.csv --lua /controller/trainticket/loads/basic.lua &
echo "Starting load..."

java -jar /controller/httploadgenerator.jar director --ip localhost --load /controller/trainticket/loads/spiky_workload.csv.csv -o exp2-localhost.csv --lua /controller/trainticket/loads/high-failures.lua --timeout=3000


echo "Start clean up..."
kubectl delete -f /controller/loadgenerator/loadgenerator-slave-1.yaml


echo "Clean up complete!"
echo "Finished experiment 3!"
