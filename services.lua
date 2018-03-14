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
services.championImage = "/lol/static-data/v3/champions/champioID?locale=en_US&champData=image"

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

	network.request(services.url..urlService..services.key, "GET", networkListener, params)

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


return services

