local json = require ( "json" )
local globals = require( "globals" )
local storyboard = require( "storyboard" )

local services = {}


services.key = "?api_key=RGAPI-deeedc05-9e2e-4b80-ab1d-f8a3ea1baefe" 
services.key2 = "&api_key=RGAPI-deeedc05-9e2e-4b80-ab1d-f8a3ea1baefe" 		


services.url = nil					-- DESENV
--local url = "https://na1.api.riotgames.com"					-- PRODUCAO


services.summonerByName = "/lol/summoner/v3/summoners/by-name/"
services.positions = "/lol/league/v3/positions/by-summoner/"
services.activeGame = "/lol/spectator/v3/active-games/by-summoner/"
services.championImage = "/lol/static-data/v3/champions/{championid}?locale=en_US&champData=image"
services.recents= "/lol/match/v3/matchlists/by-account/{accountid}?endIndex=20"
services.championInfo= "http://mobileinteligence.com/lolserver/static.jsp?idChampion="
services.championImageLocal= "http://mobileinteligence.com/lolserver/champions/"
services.matches="/lol/match/v3/matches/"
services.composition="http://mobileinteligence.com/lolserver/composition.jsp?idChampion="
services.listChampionsCodes="http://mobileinteligence.com/lolserver/listChampionsCodes.jsp"

services.jsonReturned = nil
services.screenBack = nil
services.serverName = nil

function services:callService( urlService, screenDest )

	local headers = {}
	headers["Content-Type"] = "application/json"
	local params = {}
	params.headers = headers

	function networkListener(event)
		if event.isError then

        	globals:removeDialog()
			timer.performWithDelay( 1000, 	
				function() 
					globals:showDialog("The Internet connection\nappears to be offline.", true) 
				end)
        
        elseif event.phase == "began" then

        elseif event.phase == "ended" then
			
        	globals:removeDialog()     	
        	local decoded, pos, msg = json.decode( event.response )

			if not decoded then
				globals:showDialog("Decode failed at "..tostring(pos)..": "..tostring(msg) , false)
			else
				if decoded.status ~= nil then
					if decoded.status.status_code == 403 then

						local msg = "Problem to data access.\nTry again later. (Error "..decoded.status.status_code..")"
						timer.performWithDelay( 1000, 
						function() 
							erroDialog(msg) 
						end)

					elseif decoded.status.status_code == 404 then

						local msg = "Summoner not found."
						timer.performWithDelay( 1000, 
						function() 
							erroDialog(msg) 
						end)

					elseif decoded.status.status_code == 503 then
						local msg = "RIOT: Service in update.\nPlease wait a minute."
						timer.performWithDelay( 1000, 
						function() 
							erroDialog(msg) 
						end)

					end
				else
					services.jsonReturned = decoded
					if screenDest ~= nil then
						storyboard.gotoScene(screenDest, "fade", 1000)

					end
				end
			    
			end

	    end
	end

	function erroDialog(text)
		globals:showDialog(text, true)
	end

	network.request(string.gsub(services.url..urlService..services.key, " ", "%%20"), "GET", networkListener, params)

end 

function services:setServerService(  )

	local server = services.serverName

	if server == "BR" then
		services.url = "https://br1.api.riotgames.com"
	elseif server == "EUNE" then 
 		services.url = "https://br1.api.riotgames.com"
	elseif server == "EUW" then
		services.url = "https://br1.api.riotgames.com"
	elseif server == "JP" then
		services.url = "https://jp1.api.riotgames.com"
	elseif server == "KR" then
		services.url = "https://kr.api.riotgames.com"
	elseif server == "LAN" then
		services.url = "https://la1.api.riotgames.com"
	elseif server == "LAS" then
		services.url = "https://la2.api.riotgames.com"
	elseif server == "NA" then
		services.url = "https://na1.api.riotgames.com"
	elseif server == "OCE" then
		services.url = "https://oc1.api.riotgames.com"
	elseif server == "TR" then
		services.url = "https://tr1.api.riotgames.com"
	elseif server == "RU" then
		services.url = "https://ru.api.riotgames.com"
	elseif server == "PBE" then
		services.url = "https://pbe1.api.riotgames.com"
	end
end

function services:getGameQueue(gameQueueId)

	if gameQueueId == 420 or gameQueueId == "RANKED_SOLO_5x5" then
		return "5v5 Ranked Solo"
	elseif gameQueueId == 440 or gameQueueId == "RANKED_FLEX_SR" then
		return "5v5 Ranked Flex" 
	elseif gameQueueId == 470 then
		return "3v3 Ranked Flex"
	elseif gameQueueId == 410 then
		return "5v5 Ranked Dynamic"
	elseif gameQueueId == 450 then
		return "5v5 ARAM"
	elseif gameQueueId == 430 then
		return "5v5 Blind Pick"
	elseif gameQueueId == 800 then
		return "Co-op vs. AI Intermediate Bot"
	elseif gameQueueId == 810 then
		return "Co-op vs. AI Intro Bot"
	elseif gameQueueId == 820 then
		return "Co-op vs. AI Beginner Bot"
	elseif gameQueueId == 830 then
		return "Co-op vs. AI Intro Bot"
	elseif gameQueueId == 840 then
		return "Co-op vs. AI Beginner Bot"
	elseif gameQueueId == 850 then
		return "Co-op vs. AI Intermediate Bot"
	else 
		return "NORMAL_GAME"
	end
end


return services

