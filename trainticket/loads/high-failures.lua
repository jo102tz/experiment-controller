-- Global variables (initialized at load driver startup)
-- IP address of TrainTicket
prefix = "http://ts-ui-dashboard:8080"
-- Number of users
no_of_users = 1000
-- Errornous input for travel query (same for every user)
json_travel_fail = "{\"startingPlace\": \"Shan Hai\",\"endPlace\": \"Tai Yuan\",\"departureTime\":\"2020-05-27\"}"
-- Data for querying booking list (same for every user)
json_queryOrders = "{\"enableStateQuery\": false,\"enableTravelDateQuery\": false,\"enableBoughtDateQuery\": false,\"travelDateStart\": null,\"travelDateEnd\": null,\"boughtDateStart\": null,\"boughtDateEnd\": null}"

--[[
	Gets called at the beginning of each "call
cycle", perform as much work as possible here.
	Initialize all global variables here.
	Note that math.random is already initialized
using a fixed seed (generatorId) for reproducibility.
--]]
function onCycle(generatorId)
    -- Determine user ID
    local my_user_id = generatorId % no_of_users

    -- Payload Definitions for that user
    -- Login Info
    json_login = "{\"email\": \"user".. my_user_id.. "@test.com\",\"password\": \"user".. my_user_id.. "\",\"verificationCode\":\"1234\"}"

    -- Determine Train and Food
    -- 1 Shang Hai - Su Zhou            (TripId: D1345, Food)
    -- 2 Shang Hai - Nan Jing           (Z1234, No Food)
    -- 3 Shang Hai - Shi Jia Zhuang     (Z1234, No Food)
    -- 4 Shang Hai - Tai Yuan           (T1235, No Food)
    -- 5 Su Zhou - Shang Hai            (G1234, Food)
    -- 6 Nan Jing - Shang Hai           (G1234, Food)
    -- 7 Shi Jia Zhuang - Shang Hai     (Z1236, No Food)
    -- 8 Tai Yuan - Shang Hai           (Z1236, No Food)
    travel_decider = math.random(8)
    json_travel = "{\"departureTime\":\"2020-05-27\","
    json_food = "{\"date\": \"2020-05-27\","
    if travel_decider < 5 then
        json_travel = json_travel.. "\"startingPlace\": \"Shang Hai\","
        json_food = json_food.. "\"startStation\": \"Shang Hai\","
        if travel_decider % 4 == 1 then
            json_travel = json_travel.. "\"endPlace\": \"Su Zhou\"}"
            json_reserve_prefix = "{\"tripId\": \"D1345\",\"from\": \"Shang Hai\",\"to\": \"Su Zhou\",\"foodType\": 1,\"foodName\": \"Soup\",\"foodPrice\": 3.7,\"stationName\": \"\",\"storeName\": \"\","
            json_pay_prefix = "{\"tripId\": \"D1345\","
            json_food = json_food.. "\"endStation\":\"Su Zhou\",\"tripId\": \"D1345\"}"
        elseif travel_decider % 4 == 2 then
            json_travel = json_travel.. "\"endPlace\": \"Nan Jing\"}"
            json_reserve_prefix = "{\"tripId\": \"Z1234\",\"from\": \"Shang Hai\",\"to\": \"Nan Jing\",\"foodType\": 0,"
            json_pay_prefix = "{\"tripId\": \"Z1234\","
            json_food = json_food.. "\"endStation\":\"Nan Jing\",\"tripId\": \"Z1234\"}"
        elseif travel_decider % 4 == 3 then
            json_travel = json_travel.. "\"endPlace\": \"Shi Jia Zhuang\"}"
            json_reserve_prefix = "{\"tripId\": \"Z1234\",\"from\": \"Shang Hai\",\"to\": \"Shi Jia Zhuang\",\"foodType\": 0,"
            json_pay_prefix = "{\"tripId\": \"Z1234\","
            json_food = json_food.. "\"endStation\":\"Shi Jia Zhuang\",\"tripId\": \"Z1234\"}"
        else
            json_travel = json_travel.. "\"endPlace\": \"Tai Yuan\"}"
            json_reserve_prefix = "{\"tripId\": \"T1235\",\"from\": \"Shang Hai\",\"to\": \"Tai Yuan\",\"foodType\": 0,"
            json_pay_prefix = "{\"tripId\": \"T1235\","
            json_food = json_food.. "\"endStation\":\"Tai Yuan\",\"tripId\": \"T1235\"}"
        end
    else
        json_travel = json_travel.. "\"endPlace\": \"Shang Hai\","
        json_food = json_food.. "\"endStation\": \"Shang Hai\","
        if travel_decider % 4 == 1 then
            json_travel = json_travel.. "\"startingPlace\": \"Su Zhou\"}"
            json_reserve_prefix = "{\"tripId\": \"G1234\",\"from\": \"Su Zhou\",\"to\": \"Shang Hai\",\"foodType\": 1,\"foodName\": \"Egg Soup\",\"foodPrice\": 3.2,\"stationName\": \"\",\"storeName\": \"\","
            json_pay_prefix = "{\"tripId\": \"G1234\","
            json_food = json_food.. "\"startStation\":\"Su Zhou\",\"tripId\": \"G1234\"}"
        elseif travel_decider % 4 == 2 then
            json_travel = json_travel.. "\"startingPlace\": \"Nan Jing\"}"
            json_reserve_prefix = "{\"tripId\": \"G1234\",\"from\": \"Nan Jing\",\"to\": \"Shang Hai\",\"foodType\": 1,\"foodName\": \"Egg Soup\",\"foodPrice\": 3.2,\"stationName\": \"\",\"storeName\": \"\","
            json_pay_prefix = "{\"tripId\": \"G1234\","
            json_food = json_food.. "\"startStation\":\"Nan Jing\",\"tripId\": \"G1234\"}"
        elseif travel_decider % 4 == 3 then
            json_travel = json_travel.. "\"startingPlace\": \"Shi Jia Zhuang\"}"
            json_reserve_prefix = "{\"tripId\": \"Z1236\",\"from\": \"Shi Jia Zhuang\",\"to\": \"Shang Hai\",\"foodType\": 0,"
            json_pay_prefix = "{\"tripId\": \"Z1236\","
            json_food = json_food.. "\"startStation\":\"Shi Jia Zhuang\",\"tripId\": \"Z1236\"}"
        else
            json_travel = json_travel.. "\"startingPlace\": \"Tai Yuan\"}"
            json_reserve_prefix = "{\"tripId\": \"Z1236\",\"from\": \"Tai Yuan\",\"to\": \"Shang Hai\",\"foodType\": 0,"
            json_pay_prefix = "{\"tripId\": \"Z1236\","
            json_food = json_food.. "\"startStation\":\"Tai Yuan\",\"tripId\": \"Z1236\"}"
        end
    end

    json_reserve = json_reserve_prefix.. "\"contactsId\": \"4d2a46c7-71cb-4cf1-a5bb-b68406d9da6f\",\"seatType\": \"2\",\"date\": \"2020-05-27\"}"

    -- Determine Assurance (70% No assurance, 30% assurance)
    local assurance_decider = math.random(100)
    if assurance_decider < 70 then
        json_reserve = json_reserve.. "\"assurance\": 0}"
    else
        json_reserve = json_reserve.. "\"assurance\": 1}"
    end
end

--[[
	Gets called with ever increasing callnums for
each http call until it returns nil.
	Once it returns nil, onCycle() is called again
and callnum is reset to 1 (Lua convention).
	Here, you can use our HTML helper functions
for conditional calls on returned texts (usually HTML,
thus the name).
	We offer:
	- html.getMatches( regex )
		Returns all lines in the returned text
stream that match a provided regex.
	- html.extractMatches( prefixRegex,
postfixRegex )
		Returns all matches that are preceeded
by a prefixRegex match and followed by a postfixRegex
match.
		The regexes must one unique match for
each line in which they apply.
	- html.extractMatches( prefixRegex,
matchingRegex, postfixRegex )
		Variant of extractMatches with a
matching regex defining the string that is to be
extracted.
--]]
function onCall(callnum)
    if callnum == 1 then
        -- Generate Login Picture
        return prefix.. "/verification/generate"
    elseif callnum == 2 then
        -- Login with Credentials
        return "[POST]{".. json_login.. "}".. prefix.. "/login"
    elseif callnum == 3 then
        -- Search for trains #1 (80% errornous input)
        local error_decider = math.random(100)
        if error_decider < 80 then
            return "[POST]{".. json_travel_fail.. "}".. prefix.. "/travel/query"
        else
            return "[POST]{".. json_travel.. "}".. prefix.. "/travel/query"
        end
    elseif callnum == 4 then
        -- Search for trains #2
        local error_decider2 = math.random(100)
        if error_decider2 < 80 then
            return "[POST]{".. json_travel_fail.. "}".. prefix.. "/travel2/query"
        else
            return "[POST]{".. json_travel.. "}".. prefix.. "/travel2/query"
        end
    elseif callnum == 5 then
        -- Retrieve contact data for booking
        return prefix.. "/contacts/findContacts"
    elseif callnum == 6 then
        -- Retrieve assurance information
        return prefix.. "/assurance/getAllAssuranceType"
    elseif callnum == 7 then
        -- Get food information
        return "[POST]{".. json_food.. "}".. prefix.. "/food/getFood"
    elseif callnum == 8 then
        -- Trains starting with G or D use preserve for booking, all other preserveOther (first execute the wrong one)
        -- Book Ticket
        if travel_decider == 1 or travel_decider == 5 or travel_decider == 6 then
            return "[POST]{".. json_reserve.. "}".. prefix.. "/preserveOther"
        else
            return "[POST]{".. json_reserve.. "}".. prefix.. "/preserve"
        end
    elseif callnum == 9 then
        -- Trains starting with G or D use preserve for booking, all other preserveOther
        -- Book Ticket # 2
        if travel_decider == 1 or travel_decider == 5 or travel_decider == 6 then
            return "[POST]{".. json_reserve.. "}".. prefix.. "/preserve"
        else
            return "[POST]{".. json_reserve.. "}".. prefix.. "/preserveOther"
        end
    elseif callnum == 10 then
        -- Get OrderID from last response
        orderId = html.extractMatches("(?:\"id\":\")", "(.*?)", "(?:\")")
        -- Load order list #1
        return "[POST]{".. json_queryOrders.. "}".. prefix.. "/order/queryForRefresh"
    elseif callnum == 11 then
        -- Load order list #2
        return "[POST]{".. json_queryOrders.. "}".. prefix.. "/orderOther/queryForRefresh"
    elseif callnum == 12 then
        -- Pay ticket
        return "[POST]{".. json_pay_prefix.. "\"orderId\": \"".. orderId[1].. "\"}}".. prefix.. "/inside_payment/pay"
    elseif callnum == 13 then
        -- Collect ticket
        return "[POST]{{\"orderId\": \"".. orderId[1].. "\"}}".. prefix.. "/execute/collected"
    elseif callnum == 14 then
        -- Enter station
        return "[POST]{{\"orderId\": \"".. orderId[1].. "\"}}".. prefix.. "/execute/execute"
    else
        return nil
    end
end
