#!/bin/bash
echo "Starting setup for experiment 1..."

kubectl version --client

echo "Start TeaStore application..."
kubectl create -f /controller/teastore/teastore-clusterip.yaml
echo "Application up!"

echo "Start load generator slaves..."
kubectl create -f /controller/loadgenerator/loadgenerator-slave-1.yaml
echo "Generators up!"

echo "Setup complete!"

echo "Tearing down after 20 seconds.."
for i in {1..2}
do
echo "Waited for $i seconds..."
sleep 1
done

nslookup loadgenerator-slave-1
nslookup teastore-webui

java -jar /controller/loadgenerator/httploadgenerator.jar loadgenerator & 


java -jar /controller/loadgenerator/httploadgenerator.jar director --ip loadgenerator-slave-1 --load /controller/teastore/loads/increasingHighIntensity.csv -o testlog.csv --lua /controller/teastore/loads/teastore_browse.lua
echo "Starting load..."
java -jar /controller/loadgenerator/httploadgenerator.jar director --ip 10.100.115.230 --load /controller/teastore/loads/increasingHighIntensity.csv -o testlog.csv --lua /controller/teastore/loads/teastore_browse.lua


java -jar /controller/lloadgenerator/httploadgenerator.jar director --ip localhost --load /controller/teastore/loads/increasingHighIntensity.csv -o testlog.csv --lua /controller/teastore/loads/teastore_browse.lua


echo "Start clean up..."
#kubectl delete -f /controller/loadgenerator/loadgenerator-slave-1.yaml
kubectl delete -f /controller/teastore/teastore-clusterip.yaml


echo "Clean up complete!"
echo "Finished!"

