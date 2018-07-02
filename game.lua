
---------------------------------------------------------------------------------
-- Intro Screen 
---------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
system.setIdleTimer( false ) 

local globals = require( "globals" )
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local services = require("services")
local json = require ( "json" )
local translations = require("translations")
local scene = storyboard.newScene()

storyboard.removeAll()

display.setDefault( "anchorX", 0.0 )    -- default to TopLeft anchor point for new objects
display.setDefault( "anchorY", 0.0 )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

--storyboard.gotoScene(  "title", "fade", 5000  ) 

local xCenter = display.contentCenterX
local yCenter = display.contentCenterY
local summoner
local jsonReturned
local scrollView
local i = 1
local j = 1
local k = 1

local q = 1
local r = 1
local s = 1

local left = 10
local left2 = 10
local left3 = 10

local language = system.getPreference( "locale", "language" ) 

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view




end
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	
	
	screenGroup.x = -500
	transition.to( screenGroup, { time=2000, x=0, iterations=1, transition=easing.inOutElastic } )
	
	local background = display.newImage( screenGroup, "images/back_detail.png" , 0, 0 ) 
	background:scale( 0.93, 1.0 )

	summoner = services.jsonReturned

	scrollView = widget.newScrollView
	{
		top = yCenter-160,
    	left = -500,
	    width = 350,
	    height = 350,
	    --scrollWidth = 0,
	    --scrollHeight = 50,
	    hideBackground = true,
	    horizontalScrollDisabled = true,
	    listener = scrollListener
	}

	transition.to( scrollView, { time=2000, x=20, iterations=1, transition=easing.inOutElastic } )

	function networkListener(event)
		if event.isError then

        	globals:removeDialog()
			timer.performWithDelay( 1000, 	
				function() 
					globals:showDialog(translations["error.notconnected"][language], true) 
				end)
        
        elseif event.phase == "began" then

        elseif event.phase == "ended" then
			  	
        	local decoded, pos, msg = json.decode( event.response )

			if not decoded then
				--globals:showDialog("Decode failed at "..tostring(pos)..": "..tostring(msg) , false)
			else
				if decoded.status ~= nil then
					globals:removeDialog()
					if decoded.status.status_code == 403 then
						local msg = translations["error.dataaccess"][language].." (Error "..decoded.status.status_code..")"
						timer.performWithDelay( 1000, 
						function() 
							erroDialog(msg) 
						end)

					elseif decoded.status.status_code == 404 then

						local msg = translations["error.summoner"][language]..summoner.name.."?"
						timer.performWithDelay( 1000, 
						function() 
							globals:showDialogError(msg, true, "dashboard") 
						end)

					elseif decoded.status.status_code == 503 then
						globals:removeDialog()
						local msg = translations["error.unavaliable"][language]
						timer.performWithDelay( 1000, 
						function() 
							erroDialog(msg) 
						end)

					end
				else
					
					jsonReturned = decoded
					init()

				end
			end
	    end
	end

	network.request(services.url..services.activeGame..summoner.id..services.key, "GET", networkListener, params)


	

	function init()

		local participants = jsonReturned.participants

		for k, v in pairs( participants ) do
		    local participant  = v
			
			paticipantData(participant)
			imageData(participant)
 
		end

		local title = display.newText( screenGroup, translations["game.ingame"][language], xCenter-50, 30, "fonts/zombie.ttf", 24 )
		title:setFillColor(0,0,0)

		local info = display.newText( screenGroup, translations["game.forinfomation"][language], 50, 60, native.systemFont, 18 )
		info:setFillColor(0,0,0)

		local gameType = services:getGameQueue(jsonReturned.gameQueueConfigId)
		local gameMode = display.newText( screenGroup, gameType, 120, 90, "fonts/zombie.ttf", 18 )
		gameMode:setFillColor(0,0,0)

		local teamBlue = display.newText( screenGroup, translations["game.teamblue"][language], 40, 120, "fonts/zombie.ttf", 20 )
		teamBlue:setFillColor(41/255,128/255,185/255)

		local teamRed = display.newText( screenGroup, translations["game.teamred"][language], xCenter+10, 120, "fonts/zombie.ttf", 20 )
		teamRed:setFillColor(231/255,76/255,60/255)

		local function onClickBack(event)

			transition.to( screenGroup, { time=1000, x=500, iterations=1, transition=easing.inOutElastic, onComplete = function() 
																															storyboard.gotoScene("login", "fade", 250)
																															storyboard.removeAll()
																														end } )
			transition.to( scrollView, { time=1000, x=500, iterations=1, transition=easing.inOutElastic, onComplete = 	function() 
																															scrollView.isVisible = false 
																														end } )


		end

		local btnBack = widget.newButton(
			{
		        label = translations["game.back"][language],
		        emboss = false,
		        width = 100,
		        height = 30,
		        x = xCenter - 50,
		        y = yCenter + 180,
		        defaultFile = "images/button_1.png",
		        fontSize = 12,
		     	labelColor = { default={1,1,1} }
	    	}
	    )

	    btnBack:addEventListener( "tap", onClickBack )

		screenGroup:insert( btnBack )

		

	end

	function paticipantData(participant, position)

		if q == 6 then
			i = 1
		end  

		if (q / 5 < 1) then
			left = 10
		elseif (q / 5 > 1) then
			left = 180
		end

		local function detailsSummonerListener(event)

			transition.to( screenGroup, { time=1000, x=500, iterations=1, transition=easing.inOutElastic, onComplete = 
				function() 
					services.screenBack = "game"
					services:callService(services.summonerByName..string.gsub(participant.summonerName, " ", "%%20"), "dashboard")
				end } )
			transition.to( scrollView, { time=1000, x=500, iterations=1, transition=easing.inOutElastic, onComplete = 	function() 
																															scrollView.isVisible = false 
																														end } )


		end


		local leftPosition = left+40
		local topPosition = (i*10)+20

		local summonerName = display.newText( screenGroup, participant.summonerName, leftPosition, topPosition, "fonts/zombie.ttf", 16 )	
		summonerName:addEventListener( "tap", detailsSummonerListener )

		if (q / 5 < 1) then
			summonerName:setFillColor(41/255,128/255,185/255)
		elseif (q / 5 > 1) then
			summonerName:setFillColor(231/255,76/255,60/255)
		else
			summonerName:setFillColor(41/255,128/255,185/255)
		end		

		i = i + 2
		i = i + 4

		q = q + 1
		scrollView:insert( summonerName )

		rankData(participant, leftPosition, topPosition)


	end

	function rankData(participant, leftPosition, topPosition)


		function networkListenerRank(event) 
			
			if event.phase == "ended" then

				local positions, pos, msg = json.decode( event.response )
				local isFound = false

	    		if positions.status == nil then

					for k,v in pairs( positions ) do
						--sleep(1)
	    				local position = v
						local gameType = services:getGameQueue(jsonReturned.gameQueueConfigId)
						local positionQueueType = services:getGameQueue(position.queueType)

	    				if positionQueueType == gameType then
	    					isFound = true
	    					if position ~= nil then

	    						print( "images/tier-icons/"..string.lower( position.tier.."_"..position.rank ) ..".png" )

								local tierImage = display.newImage( screenGroup, "images/tier-icons/"..string.lower( position.tier.."_"..position.rank ) ..".png", leftPosition, topPosition+10 )
								tierImage:scale( 0.25, 0.2 )
								local rank = display.newText( screenGroup, position.tier.." "..position.rank, leftPosition+50, topPosition+20, native.systemFont, 13 )
								rank:setFillColor( 0, 0, 0 )
								scrollView:insert( tierImage )
								scrollView:insert( rank )

							else
								isFound = false
							end

	    					break
	    				end
	    			end

	    			if isFound == false then
			    		local rank = display.newText( screenGroup, "UNRANKED", leftPosition+10, topPosition+20, native.systemFont, 13 )
						rank:setFillColor( 0, 0, 0 )
						scrollView:insert( rank )
	    			end
	    		
	    		end

			end
		end
		
		network.request(services.url..services.positions..participant.summonerId..services.key, "GET", networkListenerRank, params)	

	end

	function imageData(participant)

		local function detailsSummonerListener(event)
			transition.to( screenGroup, { time=1000, x=500, iterations=1, transition=easing.inOutElastic, onComplete = 
				function() 
					services.screenBack = "game"
					services:callService(services.summonerByName..string.gsub(participant.summonerName, " ", "%%20"), "dashboard")
				end } )
			transition.to( scrollView, { time=1000, x=500, iterations=1, transition=easing.inOutElastic, onComplete = 	function() 
																															scrollView.isVisible = false 
																														end } )
		end

		if s == 6 then
			k = 1
		end  

		if (s / 5 < 1) then
			left3 = 10
		elseif (s / 5 > 1) then
			left3 = 180
		end

		k = k + 2
		local circle = display.newCircle( screenGroup, left3, (k*10), 10 )
		local paint = {
		    type = "image",
		    filename = "images/icons/interrogation.png"
		}
		circle.fill = paint	
		-- circle.width = 40
		-- circle.height = 35
		circle:addEventListener( "tap", detailsSummonerListener )
		--circle:setFillColor(241/255, 229/255, 186/255)
		k = k + 4

		s = s + 1

		scrollView:insert( circle )


		local imageTemp = "profile_"..participant.summonerId..".png"
		local function networkListenerImage( event )
		  if event.isError then
		        print ( "Network error - download failed" )
		  elseif(event.phase == "ended") then
		  		globals:removeDialog()
		    	if event.response.fullPath ~= nil then
		    	
					local paint = {
					    type = "image",
					    filename = imageTemp,
					    baseDir = system.TemporaryDirectory
					}
					circle.fill = paint	
					circle.width = 40
					circle.height = 35
				else

					local paint = {
					    type = "image",
					    filename = "images/icons/interrogation.png"
					}
					circle.fill = paint	
					circle.width = 40
					circle.height = 35

		    	end 
		    end
		end
	
		local function downloadPhoto()

			local photoLink =  services.championImageLocal..participant.championId..".png"
			local params = {}
			params.progress = "download"
			params.response = {
				filename = imageTemp,
		  		baseDirectory = system.TemporaryDirectory
			}
			network.request( photoLink, "GET", networkListenerImage,  params )
		end
		
		downloadPhoto()

	end

	local clock = os.clock
	function sleep(n)  -- seconds
		local t0 = clock()
		while clock() - t0 <= n do end
	end

	globals:showDialog(translations["game.wait"][language], false)

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view	

	
end
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view


end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene

