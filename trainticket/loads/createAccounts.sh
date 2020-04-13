#!/usr/bin/env bash

# Needs number of accounts to be created as first parameter

set +e
# Admin Login
curl -X POST -H "Content-Type: application/json" -d '{"name": "adminroot","password": "adminroot"}' http://10.1.3.43/account/adminlogin > temp.txt

# Extract Login UUID from response
loginId=$(grep -zoP '"id":\s*\K[^\s,]*(?=\s*,)' temp.txt)
echo "LoginID: $loginId"
rm temp.txt

# Create User Accounts
for ((i = 1 ; i <= $1 ; i++)); do
    payload="{\"loginId\": $loginId, \"name\": \"user$i\", \"password\": \"user$i\", \"gender\": 1, \"email\": \"user$i@test.com\", \"documentType\": 1, \"documentNum\": 1}"
    curl -X POST -H "Content-Type: application/json" -d "$payload" http://10.1.3.43/adminuser/addUser
done
set -e
