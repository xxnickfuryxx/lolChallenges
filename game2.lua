
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

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	local background = display.newImage( screenGroup, "images/back_detail.png" , 0, 0 ) 
	background:scale( 0.93, 1.0 )

end
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	
	
	
	summoner = services.jsonReturned

	scrollView = widget.newScrollView
	{
		top = yCenter-180,
    	left = 20,
	    width = 350,
	    height = 350,
	    --scrollWidth = 0,
	    --scrollHeight = 50,
	    hideBackground = true,
	    listener = scrollListener
	}

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

						local msg = "Problem to data access.\nTry again later222. (Error "..decoded.status.status_code..")"
						timer.performWithDelay( 1000, 
						function() 
							erroDialog(msg) 
						end)

					elseif decoded.status.status_code == 404 then

						local msg = "This summoner not in game.\nWant to see more information\nabout '"..summoner.name.."'?"
						timer.performWithDelay( 1000, 
						function() 
							globals:showDialogError(msg, true, "dashboard") 
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

		    function networkListenerRank(event)
				if event.isError then
	        
		        elseif event.phase == "began" then

	        	elseif event.phase == "ended" then
	        		local positions, pos, msg = json.decode( event.response )

	        		if positions.status == nil then

	        			if r == 6 then
							j = 1
						end  

						if (r / 5 < 1) then
							left2 = 10
						elseif (r / 5 > 1) then
							left2 = 180
						end

						j = j + 2
						for k,v in pairs( positions ) do
	        				local position = v
	        					rankData(position)
	        				break
	        			end
						
						j = j + 4
						r = r + 1
	        		
	        		end
			   
	    		end
	    	end
			network.request(services.url..services.positions..participant.summonerId..services.key, "GET", networkListenerRank, params)	
			paticipantData(participant)
			imageData(participant)
 
		end

		local title = display.newText( screenGroup, "In Game...", xCenter-50, 30, native.systemFontBold, 24 )
		title:setFillColor(0,0,0)

		local info = display.newText( screenGroup, "...for more information, touch player", 50, 60, native.systemFont, 18 )
		info:setFillColor(0,0,0)

		local teamBlue = display.newText( screenGroup, "Team Blue", 40, 100, native.systemFontBold, 20 )
		teamBlue:setFillColor(41/255,128/255,185/255)

		local teamRed = display.newText( screenGroup, "Team Red", xCenter+10, 100, native.systemFontBold, 20 )
		teamRed:setFillColor(231/255,76/255,60/255)

		local function onClickBack(event)

			scrollView.isVisible = false
			storyboard.gotoScene("login", "fade", 250)
			storyboard.removeAll()
		end

		local btnBack = widget.newButton(
			{
		        label = "BACK",
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
			services.screenBack = "game"
			services:callService(services.summonerByName..participant.summonerName, "dashboard")
			scrollView.isVisible = false
		end

		local summonerName = display.newText( screenGroup, participant.summonerName, left+40, (i*10)+20, native.systemFontBold, 15 )	
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


	end

	function rankData(position)

		if position ~= nil then
			local rank = display.newText( screenGroup, position.tier.." "..position.rank, left2+40, (j*10)+20, native.systemFont, 16 )
			rank:setFillColor( 0, 0, 0 )
			scrollView:insert( rank )
		end
		

	end

	function imageData(participant)


		local function networkListenerChamp()
			if event.isError then
	        	print( "Error ")
	        elseif event.phase == "began" then

        	elseif event.phase == "ended" then
        		local champion, pos, msg = json.decode( event.response )

        		k = k + 2
				local circle = display.newCircle( screenGroup, left3, (k*10), 10 )
				k = k + 4

				s = s + 1

				scrollView:insert( circle )

				local imageTemp = "profile_"..participant.summonerId..".png"
				local function networkListenerImage( event )
				  	if ( event.isError ) then
				        print ( "Network error - download failed" )
				  	else
				    	if event.response.fullPath ~= nil then
				    		local imgtmp = event.response.fullPath
						
							if system.getInfo( "environment" ) ~= "simulator" then
								local paint = {
								    type = "image",
								    filename = imgtmp
								}
								print( "Teste:"..imgtmp )
								circle.fill = paint	
								circle.width = 40
								circle.height = 35
							else
								local paint = {
								    type = "image",
								    filename = "images/interrogation.png"
								}
								circle.fill = paint	
								circle.width = 40
								circle.height = 35
							end
						else
							local paint = {
								    type = "image",
								    filename = "images/interrogation.png"
								}
								circle.fill = paint	
								circle.width = 40
								circle.height = 35
				    	end 
				   	end
				end

				display.loadRemoteImage( "http://ddragon.leagueoflegends.com/cdn/6.24.1/img/champion/"..champion.image.full, "GET", networkListenerImage, champion.image.full, system.TemporaryDirectory,-500, -500 )

        	end
		end
		network.request(services.url..string.gsub(services.championImage, "champioID", participant.championId)..services.key2, "GET", networkListenerChamp, params)	

		if s == 6 then
			k = 1
		end  

		if (s / 5 < 1) then
			left3 = 10
		elseif (s / 5 > 1) then
			left3 = 180
		end

	end

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

