
display.setStatusBar(display.HiddenStatusBar)
system.setIdleTimer( false ) 

local storyboard = require( "storyboard" )

	local options = {
	    effect = "slideLeft",
	    time = 800,
	    params = { any="vars", can="go", here=true }	-- optional params table to pass to scene event
	}
	
storyboard.gotoScene("splash", "fade", 1000)


-- storyboard.gotoScene("composition")


-- local json = require ( "json" )

-- local function getDataExtra(gameId, playerId)

-- 	local player = playerId
-- 	local participantId = nil

-- 	local function networkListenerMatch(event) 

-- 		if event.phase == "ended" then
-- 			local decoded = json.decode( event.response )
-- 			if not decoded then
-- 				--globals:showDialog("Decode failed at "..tostring(pos)..": "..tostring(msg) , false)
-- 			else
-- 				for k,v in pairs(decoded.participantIdentities) do
-- 					local participantsIdenty = v
-- 					if participantsIdenty.player.accountId == player then
-- 						participantId = participantsIdenty.participantId
-- 						break
-- 					end
-- 				end

-- 				for k,v in pairs(decoded.participants) do
-- 					local participant = v
-- 					if participantId == participant.participantId then

-- 						print( "" )
-- 						print( "" )
-- 						print( "" )
-- 						print( "Venceu a partida? "..tostring(participant.stats.win) )
-- 						print( "Status "..participant.stats.kills.."/"..participant.stats.deaths.."/"..participant.stats.assists )
-- 						print( "Ouro ganho "..(participant.stats.goldEarned/1000).."k" )

-- 						break
-- 					end
-- 				end
-- 			end

-- 		end

		
-- 	end

-- 	local params = {}
-- 	network.request( "https://br1.api.riotgames.com/lol/match/v3/matches/"..gameId.."?api_key=RGAPI-632aa5f6-9b6a-4915-8a11-bc8ead06dfce", "GET", networkListenerMatch,  params )

-- end


-- getDataExtra(1361962666, 210899157)
