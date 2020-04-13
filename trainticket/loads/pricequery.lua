-- Global variables (initialized at load driver startup)
-- IP address of TrainTicket
prefix = "http://ts-ui-dashboard:8080"

--[[
	Gets called at the beginning of each "call
cycle", perform as much work as possible here.
	Initialize all global variables here.
	Note that math.random is already initialized
using a fixed seed (generatorId) for reproducibility.
--]]
function onCycle(generatorId)
    json_price = "{\"id\": \"D1345\"}"
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
    if callnum < 100000 then
        return "[POST]{".. json_price.. "}".. prefix.. "/price/query"
    else
        return nil
    end
end

