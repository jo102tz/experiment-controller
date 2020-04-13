LUA files:
basic.lua - Whole workflow which represents a real user behavior
travelquery.lua - Stimulate frontend only
stationexist.lua, pricequery.lua, trainretrieve.lua - Stimulate backend only

SH files:
createAccounts.sh <n> - Create an arbitrary number of user accounts (mandatory before executing basic.lua)
cleanOrders.sh - Execute this script while basic.lua to prevent trains from overbooking 