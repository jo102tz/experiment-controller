#!/usr/bin/env bash

# Requires: curl, grep, jq
set +e
# Get all orders
curl http://10.1.3.43/order/findAll > temp.txt
# Select all finished orders
jq '.orders[]|select(.status==6)' temp.txt > temp2.txt
# Get ID and Train numbers of them and delete them
while read id trainnumber ; do
    payload="{\"loginid\": \"1d1a11c1-11cb-1cf1-b1bb-b11111d1da1f\", \"orderId\": $id\", \"trainNumber\": \"$trainnumber}"
    curl -X POST -H "Content-Type: application/json" -d "$payload" http://10.1.3.43/adminorder/deleteOrder
done < <(jq '.|"\(.id) \(.trainNumber)"' temp2.txt)
# Get all orders
curl http://10.1.3.43/orderOther/findAll > temp.txt
# Select all finished orders
jq '.orders[]|select(.status==6)' temp.txt > temp2.txt
# Get ID and Train numbers of them and delete them
while read id trainnumber ; do
    payload="{\"loginid\": \"1d1a11c1-11cb-1cf1-b1bb-b11111d1da1f\", \"orderId\": $id\", \"trainNumber\": \"$trainnumber}"
    curl -X POST -H "Content-Type: application/json" -d "$payload" http://10.1.3.43/adminorder/deleteOrder
done < <(jq '.|"\(.id) \(.trainNumber)"' temp2.txt)
rm temp.txt
rm temp2.txt
set -e
