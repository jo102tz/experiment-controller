#!/bin/bash
echo "Starting setup for experiment 1..."

kubectl version --client

#echo "Start TeaStore application..."
#kubectl create -f /controller/teastore/teastore-clusterip.yaml
#echo "Application up!"

#echo "Start load generator slaves..."
#kubectl create -f /controller/loadgenerator/loadgenerator-slave-1.yaml
#echo "Generators up!"

echo "Setup complete!"

for i in {1..2}
do
echo "Waited for $i seconds..."
sleep 1
done

nslookup loadgenerator-slave-1
nslookup teastore-webui

java -jar /controller/httploadgenerator.jar loadgenerator & 

#java -jar /controller/loadgenerator/httploadgenerator.jar director --ip loadgenerator-slave-1 --load /controller/teastore/loads/LongcloudArrivalRates140.csv -o experiment5.csv --lua /controller/teastore/loads/teastore_buy-uncached.lua --timeout=3000
echo "Starting load..."

java -jar /controller/httploadgenerator.jar director --ip localhost --load /controller/teastore/loads/LongcloudArrivalRates140.csv -o experiment5.csv --lua /controller/teastore/loads/teastore_buy-uncached.lua --timeout=3000


echo "Start clean up..."
#kubectl delete -f /controller/loadgenerator/loadgenerator-slave-1.yaml
#kubectl delete -f /controller/teastore/teastore-clusterip.yaml


echo "Clean up complete!"
echo "Finished!"
