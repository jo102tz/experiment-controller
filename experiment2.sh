#!/bin/bash
echo "Starting setup for experiment 2..."

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


java -jar /controller/httploadgenerator.jar director --ip loadgenerator-slave-1 --load /controller/teastore/loads/increasingHighIntensity.csv -o testlog.csv --lua /controller/teastore/loads/teastore_browse.lua
echo "Starting load..."

java -jar /controller/httploadgenerator.jar director --ip localhost --load /controller/teastore/loads/LongcloudArrivalRates140.csv -o testlog.csv --lua /controller/teastore/loads/teastore_browse.lua --timeout=3000


echo "Start clean up..."
kubectl delete -f /controller/loadgenerator/loadgenerator-slave-1.yaml


echo "Clean up complete!"
echo "Finished!"
