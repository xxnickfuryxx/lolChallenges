
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
local imgtmp
local summoner
local scrollView

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	summoner = services.jsonReturned


    local background = display.newImage( screenGroup, "images/back_detail.png" , 0, 0 ) 
	background:scale( 0.93, 1.0 )

	scrollView = widget.newScrollView
	{
		top = yCenter-160,
    	left = 20,
	    width = 350,
	    height = 320,
	    hideBackground = true
	}


	local function networkListenerImage( event )
	    if ( event.isError ) then
	        print ( "Network error - download failed" )
	    else
	        imgtmp = event.response.fullPath

			local circle = display.newCircle( 30, 30, 100 )
			
			if system.getInfo( "environment" ) ~= "simulator" then
				if imgtmp == nil then
					local paint = {
					    type = "image",
					    filename = "images/interrogation.png"
					}
					circle.fill = paint	
				else
					local paint = {
					    type = "image",
					    filename = imgtmp
					}
					circle.fill = paint	
				end
			else
				local paint = {
				    type = "image",
				    filename = "images/interrogation.png"
				}
				circle.fill = paint	
			end

			circle.height = 70
			circle.width = 90
			circle:setFillColor( 255, 255, 255 )
			screenGroup:insert( circle, false )

			init()
			

	    end
	end

	display.loadRemoteImage( "http://ddragon.leagueoflegends.com/cdn/6.24.1/img/profileicon/"..summoner.profileIconId..".png", "GET", networkListenerImage, "profile.png", system.TemporaryDirectory,-500, -500 )

	function init()

		local txtNome = display.newText( screenGroup , summoner.name, xCenter-60, 60, 250, 100, native.systemFontBold, 24 )
		txtNome:setFillColor( 0.2, 0.2, 0.2 )

		local line = display.newLine( 40, 120, display.contentWidth-40, 120)
		line:setStrokeColor( 0.2, 0.2, 0.2 )
		screenGroup:insert( line, false )

		local stats = display.newText( screenGroup, "Stats - League", xCenter-40, 120, 250, 100, native.systemFont, 14 )
		stats:setFillColor( 0.2, 0.2, 0.2 )

		function onClickBack(event)
			if services.screenBack == nil then
				storyboard.gotoScene("login", "fade", 250)
			else
				storyboard.gotoScene(services.screenBack, "fade", 250)
			end
			scrollView.isVisible = false
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

	local i = 1

	function positinData(position)
		if position ~= nil then

			local queueType = display.newText( screenGroup, "Queue Type: "..position.queueType, 20, (10*i), native.systemFontBold, 18 )
			queueType:setFillColor( 0.2, 0.2, 0.2 )
			
			i = i+1

			local wins = display.newText( screenGroup, "Wins: "..position.wins, 20, (10*i)+20, native.systemFont, 18 )
			wins:setFillColor( 0.2, 0.2, 0.2 )
			local losses = display.newText( screenGroup, "Losses: "..position.losses, 180, (10*i)+20, native.systemFont, 18 )
			losses:setFillColor( 0.2, 0.2, 0.2 )

			i = i+1

			local leaguePoints = display.newText( screenGroup, "League Points: "..position.leaguePoints, 20, (10*i)+30, native.systemFont, 18 )
			leaguePoints:setFillColor( 0.2, 0.2, 0.2 )

			i = i+1

			local txtRank = display.newText( screenGroup, "Rank: "..position.tier.." ".. position.rank, 20, (10*i)+40, native.systemFont, 18 )
			txtRank:setFillColor( 0.2, 0.2, 0.2 )	

			local line = display.newText( screenGroup, "-------------------", 120, (10*i)+60, native.systemFont, 18 )
			line:setFillColor( 0.2, 0.2, 0.2 )

			scrollView:insert( queueType )
			scrollView:insert( wins )
			scrollView:insert( losses )
			scrollView:insert( leaguePoints )
			scrollView:insert( txtRank )
			scrollView:insert( line )

			i = i+10
			
		end
	end

end
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	

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

						local msg = "Problem to data access.\nTry again later222. (Error "..decoded.status.status_code..")"
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

					end
					else
					

					for k, v in pairs( decoded ) do
					    local position  = v
					    positinData(position)
					    
					end

				end
			end
	    end
	end
	network.request(services.url..services.positions..summoner.id..services.key, "GET", networkListener, params)	


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

