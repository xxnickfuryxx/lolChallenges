
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
local progressRing = require("progressRing")

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

local language = system.getPreference( "locale", "language" ) 

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	

end
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	

	local background = display.newImage( screenGroup, "images/back_detail.png" , 0, 0 ) 
	background:scale( 0.93, 1.0 )

	screenGroup.x = -500
	transition.to( screenGroup, { time=2000, x=0, iterations=1, transition=easing.inOutElastic } )

	summoner = services.jsonReturned

	scrollView = widget.newScrollView
	{
		top = yCenter-160,
    	left = -500,
	    width = 350,
	    height = 320,
	    hideBackground = true,
	    horizontalScrollDisabled = true
	}

	transition.to( scrollView, { time=2000, x=20, iterations=1, transition=easing.inOutElastic } )


	local function networkListenerImage( event )
	    if ( event.isError ) then
	    	print ( "Network error - download failed" )
	    elseif(event.phase == "ended") then
	        imgtmp = event.response.fullPath

			local circle = display.newCircle( 30, 30, 100 )
			local paint = {
			    type = "image",
			    filename = "profile.png",
			    baseDir = system.TemporaryDirectory
			}
			circle.fill = paint	

			circle.height = 70
			circle.width = 90
			circle:setFillColor( 255, 255, 255 )
			screenGroup:insert( circle, false )

			init()
			

	    end
	end

	local function downloadPhoto()
		local photoLink =  "http://ddragon.leagueoflegends.com/cdn/8.10.1/img/profileicon/"..summoner.profileIconId..".png"
		local params = {}
		params.progress = "download"
		params.response = {
			filename = "profile.png",
	  		baseDirectory = system.TemporaryDirectory
		}
		network.request( photoLink, "GET", networkListenerImage,  params )
	end

	downloadPhoto()

	function init()

		local txtNome = display.newText( screenGroup , summoner.name, xCenter-60, 60, 250, 100, "fonts/zombie.ttf", 24 )
		txtNome:setFillColor( 0.2, 0.2, 0.2 )

		local line = display.newLine( 40, 120, display.contentWidth-40, 120)
		line:setStrokeColor( 0.2, 0.2, 0.2 )
		screenGroup:insert( line, false )

		local stats = display.newText( screenGroup, translations["dashboard.stats"][language], xCenter-60, 120, 250, 100, native.systemFontBold, 14 )
		stats:setFillColor( 0.2, 0.2, 0.2 )

		function onClickBack(event)

			transition.to( screenGroup, { time=1000, x=-500, iterations=1, transition=easing.inOutElastic, onComplete = 
				function() 

					if services.screenBack == nil then
						storyboard.gotoScene("login", "fade", 250)

					else
						storyboard.gotoScene(services.screenBack, "fade", 250)
					end
					storyboard.removeAll()	

				end } )
			transition.to( scrollView, { time=1000, x=-500, iterations=1, transition=easing.inOutElastic, onComplete = 	function() 
																															scrollView.isVisible = false 
																														end } )

		end

		local btnBack = widget.newButton(
			{
		        label = translations["dashboard.back"][language],
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

	i = 1

	function positinData(position)
		if position ~= nil then

			local queueType = display.newText( screenGroup, position.queueType, 20, (10*i), "fonts/zombie.ttf", 20 )
			queueType:setFillColor( 0.2, 0.2, 0.2 )
			
			i = i+1
			local iconWin = display.newImage( screenGroup, "images/icons/win.png", 20, (10*i)+10 )
			iconWin:scale( 0.4, 0.35 )


			local wins = display.newText( screenGroup, translations["dashboard.wins"][language]..position.wins, 70, (10*i)+20, "fonts/zombie.ttf", 18 )
			wins:setFillColor( 0.2, 0.2, 0.2 )

			local losses = display.newText( screenGroup, translations["dashboard.losses"][language]..position.losses, 230, (10*i)+20, "fonts/zombie.ttf", 18 )
			losses:setFillColor( 0.2, 0.2, 0.2 )
			local iconLoss = display.newImage( screenGroup, "images/icons/lose.png", 180, (10*i)+10 )
			iconLoss:scale( 0.4, 0.35 )


			i = i+1

			local textExploitation = display.newText( screenGroup, translations["dashboard.exploitation"][language] , 100, (10*i)+45, "fonts/zombie.ttf", 18 )
			textExploitation:setFillColor( 0.2, 0.2, 0.2 )

			i = i+1

			local exploitation = display.newText( screenGroup, math.round(((position.wins/(position.losses+position.wins))*100)) .."%" , 160, (10*i)+85, "fonts/zombie.ttf", 18 )
			exploitation:setFillColor( 0.2, 0.2, 0.2 )
			local iconExploitation = display.newImage( screenGroup, "images/icons/approve.png", 120, (10*i)+50 )
			iconExploitation:scale( 1, 0.8 )

			i = i+1

			local leaguePoints = display.newText( screenGroup, translations["dashboard.leaguepoints"][language]..position.leaguePoints, 70, (10*i)+140, "fonts/zombie.ttf", 18 )
			leaguePoints:setFillColor( 0.2, 0.2, 0.2 )
			local iconLeaguePoints = display.newImage( screenGroup, "images/icons/termometer.png", 20, (10*i)+130 )
			iconLeaguePoints:scale( 0.30, 0.25 )

			i = i+1

			local tierImage = display.newImage( screenGroup, "images/tier-icons/"..string.lower( position.tier.."_"..position.rank ) ..".png", 20, (10*i)+160 )
			tierImage:scale( 0.25, 0.2 )
			local txtRank = display.newText( screenGroup, position.tier.." ".. position.rank, 70, (10*i)+170, "fonts/zombie.ttf", 18 )
			txtRank:setFillColor( 0.2, 0.2, 0.2 )	

			local line = display.newText( screenGroup, "______________________", 100, (10*i)+200, native.systemFont, 18 )
			line:setFillColor( 0.2, 0.2, 0.2 )

			scrollView:insert( queueType )
			scrollView:insert( iconWin )
			scrollView:insert( wins )
			scrollView:insert( losses )
			scrollView:insert( iconLoss )
			scrollView:insert( textExploitation )
			scrollView:insert( exploitation )
			scrollView:insert( iconExploitation )
			scrollView:insert( leaguePoints )
			scrollView:insert( iconLeaguePoints )
			scrollView:insert( tierImage )
			scrollView:insert( txtRank )
			scrollView:insert( line )
			

			i = i+25
			
		end
	end

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
			else
				if decoded.status ~= nil then
					if decoded.status.status_code == 403 then
						print( "Error 403: ".. services.url..services.positions..summoner.id..services.key)
						globals:removeDialog()
						scrollView.isVisible = false
						local msg = translations["error.dataaccess"][language].. " (Error "..decoded.status.status_code..")"
						timer.performWithDelay( 1000, 
						function() 
							erroDialog(msg) 
						end)

					elseif decoded.status.status_code == 404 then
						globals:removeDialog()
						scrollView.isVisible = false
						screenGroup.isVisible = false
						local msg = translations["summonernotfound"][language]
						timer.performWithDelay( 1000, 
						function() 
							erroDialog(msg) 
						end)
					elseif decoded.status.status_code == 503 then
						globals:removeDialog()
						scrollView.isVisible = false
						screenGroup.isVisible = false
						local msg = translations["error.unavaliable"][language]
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

					i = i-15
					local recentsMatches = display.newText( screenGroup, "Recents - Matches", xCenter-80, (10*i)+ 130, native.systemFontBold, 14 )
					recentsMatches:setFillColor( 0.2, 0.2, 0.2 )
					scrollView:insert( recentsMatches )
					i = i+5

					getRecentsData()
				end
			end
	    end
	end
	network.request(services.url..services.positions..summoner.id..services.key, "GET", networkListener, params)	


	function getRecentsData()

		local function networkListenerRecents(event)

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
					globals:showDialog("Decode failed at "..tostring(pos)..": "..tostring(msg) , false)
				else
					if decoded.status ~= nil then
						if decoded.status.status_code == 403 then
							print( tostring( summoner.accountId ) )
							print( "Error 403: ".. string.gsub( services.recents, "{accountid}", tostring( summoner.accountId ) ))
							globals:removeDialog()
							scrollView.isVisible = false
							local msg = translations["error.dataaccess"][language].. " (Error "..decoded.status.status_code..")"
							timer.performWithDelay( 1000, 
							function() 
								erroDialog(msg) 
							end)

						elseif decoded.status.status_code == 404 then
							globals:removeDialog()
							scrollView.isVisible = false
							screenGroup.isVisible = false
							local msg = translations["error.summonernotfound"][language]
							timer.performWithDelay( 1000, 
							function() 
								erroDialog(msg) 
							end)
						elseif decoded.status.status_code == 503 then
							globals:removeDialog()
							scrollView.isVisible = false
							screenGroup.isVisible = false
							local msg = translations["error.unavaliable"][language]
							timer.performWithDelay( 1000, 
							function() 
								erroDialog(msg) 
							end)
						end
					else
						local json = decoded.matches
						for k, v in pairs( json ) do
						    local recent  = v
						   	getChampionData(recent)
						   	
						end

						globals:removeDialog()
					end
				end
		    end
		end

		local urlRecents = string.gsub( services.recents, "{accountid}", tostring( summoner.accountId )  )
		network.request(services.url..urlRecents..services.key2, "GET", networkListenerRecents, params)	

		function getChampionData(recent)

			local function networkListenerChampion(event)
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
						globals:showDialog("Decode failed at "..tostring(pos)..": "..tostring(msg) , false)
					else
						if decoded.status ~= nil then
							if decoded.status.status_code == 403 then
								print( "Error 403: ".. services.championInfo..recent.champion)
								globals:removeDialog()
								scrollView.isVisible = false
								local msg = translations["error.dataaccess"][language].. " (Error "..decoded.status.status_code..")"
								timer.performWithDelay( 1000, 
								function() 
									erroDialog(msg) 
								end)

							elseif decoded.status.status_code == 404 then
								globals:removeDialog()
								scrollView.isVisible = false
								screenGroup.isVisible = false
								local msg = translations["error.summonernotfound"][language]
								timer.performWithDelay( 1000, 
								function() 
									erroDialog(msg) 
								end)
							elseif decoded.status.status_code == 503 then
								globals:removeDialog()
								scrollView.isVisible = false
								screenGroup.isVisible = false
								local msg = translations["error.unavaliable"][language]
								timer.performWithDelay( 1000, 
								function() 
									erroDialog(msg) 
								end)
							end
						else

							local champion = decoded
							getDataExtra(champion, recent)

						end
					end
			    end
			end

			network.request(services.championInfo..recent.champion, "GET", networkListenerChampion, params)	

		end

		function getDataExtra(champion, recent)

			local player = summoner.accountId
			local participantId = nil

			local function networkListenerMatch(event) 

				if event.phase == "ended" then
					local decoded = json.decode( event.response )
					if not decoded then
						--globals:showDialog("Decode failed at "..tostring(pos)..": "..tostring(msg) , false)
					else
						for k,v in pairs(decoded.participantIdentities) do
							local participantsIdenty = v
							if participantsIdenty.player.accountId == player then
								participantId = participantsIdenty.participantId
								break
							end
						end

						for k,v in pairs(decoded.participants) do
							local participant = v
							if decoded.queueId == 410 or decoded.queueId == 420 or decoded.queueId == 440 or decoded.queueId == 470 then
								if participantId == participant.participantId then

									local gameType = services:getGameQueue(decoded.queueId)

									local season = display.newText( screenGroup, translations["dashboard.season"][language]..recent.season.." - "..gameType, 20, (10*i)+130, "fonts/zombie.ttf", 18 )
									season:setFillColor( 0.2, 0.2, 0.2 )
									
									i = i+1

									local date = os.date("%d/%m/%Y %H:%M",  string.sub(recent.timestamp, 0, 10))

									local formatedDate = date
									local time = display.newText( screenGroup, formatedDate, 70, (10*i)+150, "fonts/zombie.ttf", 18 )
									time:setFillColor( 0.2, 0.2, 0.2 )
									local iconTime = display.newImage( screenGroup, "images/icons/time.png", 20, (10*i)+140 )
									iconTime:scale( 0.25, 0.20 )

									i = i+1

									local txtVictory
									local victory = display.newText( screenGroup, "", 70, (10*i)+170, "fonts/zombie.ttf", 18 )
									local iconVictory
									if participant.stats.win then
										txtVictory = translations["dashboard.victory"][language]
										victory:setFillColor(41/255,128/255,185/255)
										victory.text = txtVictory.." - "..participant.stats.kills.."/"..participant.stats.deaths.."/"..participant.stats.assists
										iconVictory = display.newImage( screenGroup, "images/icons/victory.png", 20, (10*i)+160 )
									else
										txtVictory = translations["dashboard.defeat"][language]
										victory:setFillColor(231/255,76/255,60/255)
										victory.text = txtVictory.." - "..participant.stats.kills.."/"..participant.stats.deaths.."/"..participant.stats.assists
										iconVictory = display.newImage( screenGroup, "images/icons/defeat.png", 20, (10*i)+160 )
									end
									iconVictory:scale( 0.30, 0.25 )

									i = i+1

									local gold = display.newText( screenGroup, (participant.stats.goldEarned/1000).."k" , 70, (10*i)+190, "fonts/zombie.ttf", 18 )
									gold:setFillColor( 0.2, 0.2, 0.2 )
									local iconGold = display.newImage( screenGroup, "images/icons/gold.png", 20, (10*i)+190 )
									iconGold:scale( 0.30, 0.25 )

									i = i+1

									local laneText
									local iconRolePath = "images/icons/interrogation.png"
									if recent.lane == "NONE" then
										laneText = "RANDOM"
									elseif recent.lane == "MID" then
										laneText = recent.lane
										iconRolePath = "images/icons/middle_icon.png"
									elseif recent.lane == "TOP" then
										laneText = recent.lane
										iconRolePath = "images/icons/top_icon.png"
									elseif recent.lane == "JUNGLE" then
										laneText = recent.lane
										iconRolePath = "images/icons/jungle_icon.png"
									elseif recent.lane == "BOTTOM" then
										laneText = recent.lane
										iconRolePath = "images/icons/bottom_icon.png"
									else
										laneText = recent.lane
									end


									local roleText
									if recent.role == "NONE" then
										roleText = "RANDOM"

									else
										roleText = recent.role
									end

									local role = display.newText( screenGroup, laneText.." - "..roleText, 70, (10*i)+220, "fonts/zombie.ttf", 18 )
									role:setFillColor( 0.2, 0.2, 0.2 )
									local iconRole = display.newImage( screenGroup, iconRolePath, 20, (10*i)+210 )
									iconRole:scale( 0.30, 0.25 )

									i = i+1

									local circle = display.newCircle( 20, (10*i)+240, 30 )
									local paint = {
									    type = "image",
									    filename = "images/interrogation.png"
									}
									circle.fill = paint	
									circle.width = 40
									circle.height = 35

									local champion = display.newText( screenGroup, champion.name.." - level - "..participant.stats.champLevel, 70, (10*i)+250, "fonts/zombie.ttf", 18 )
									champion:setFillColor( 0.2, 0.2, 0.2 )

									i = i+1

									local line = display.newText( screenGroup, "_________________________________", 50, (10*i)+270, native.systemFont, 18 )
									line:setFillColor( 0.2, 0.2, 0.2 )


									scrollView:insert( season )
									scrollView:insert( time )
									scrollView:insert( iconTime )
									-- scrollView:insert( lane )
									scrollView:insert( role )
									scrollView:insert( iconRole )
									scrollView:insert( circle )
									scrollView:insert( champion )
									scrollView:insert( line )
									scrollView:insert( victory )
									scrollView:insert( iconVictory )
									scrollView:insert( gold )
									scrollView:insert( iconGold )

									i = i+20

									local imageTemp = "champion_"..recent.champion..".png"
									local function networkListenerImage( event )
									  if event.isError then
									        print ( "Network error - download failed" )
										
									  elseif event.phase == "ended" then
									    	if event.response.fullPath ~= nil then
									    	
												local paint = {
												    type = "image",
												    filename = imageTemp,
												    baseDir = system.TemporaryDirectory
												}
												circle.fill = paint	
												circle.width = 60
												circle.height = 55
												circle.isVisible = true
											else

												local paint = {
												    type = "image",
												    filename = "images/interrogation.png"
												}
												circle.fill = paint	
												circle.width = 40
												circle.height = 35
												circle.isVisible = true

									    	end 
									    end
									end
								
									local function downloadPhoto()
										local photoLink =  services.championImageLocal..recent.champion..".png"
										local params = {}
										params.progress = "download"
										params.response = {
											filename = imageTemp,
									  		baseDirectory = system.TemporaryDirectory
										}
										network.request( photoLink, "GET", networkListenerImage,  params )
									end

									downloadPhoto()

									break
								end
							end
						end
					end

				end

			end

			local params = {}
			network.request( services.url..services.matches..recent.gameId..services.key, "GET", networkListenerMatch,  params )

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

