
---------------------------------------------------------------------------------
-- Intro Screen 
---------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
system.setIdleTimer( false ) 

local globals = require( "globals" )
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local services = require( "services" )
local json = require ( "json" )
local translations = require( "translations" )

local scene = storyboard.newScene()

storyboard.removeAll()

display.setDefault( "anchorX", 0.0 )    -- default to TopLeft anchor point for new objects
display.setDefault( "anchorY", 0.0 )

local language = system.getPreference( "locale", "language" ) 

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

--storyboard.gotoScene(  "title", "fade", 5000  ) 

-- Called when the scene's view does not exist:
local group
local jsonStrong
local scrollView = nil

function scene:createScene( event )
	local screenGroup = self.view


	local background = display.newImage( screenGroup, "images/back_detail.png" , 0, 0 ) 
	background:scale( 0.93, 1.0 )

	screenGroup.x = -500
	transition.to( screenGroup, { time=2000, x=0, iterations=1, transition=easing.inOutElastic } )


	local textTitle = display.newText( screenGroup, translations["composition.selectchampion"][language], 70, 50, "fonts/zombie.ttf", 24)
	textTitle:setFillColor( 0, 0, 0 )

	local champion = display.newCircle( 120, 80, 100 )
	local paint = {
	    type = "image",
	    filename = "images/icons/interrogation.png",
	    --baseDir = system.TemporaryDirectory
	}
	champion.fill = paint	

	champion.height = 140
	champion.width = 160

	local imageTemp = "champion_comp.png"
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
				champion.fill = paint	
				champion.height = 170
				champion.width = 180
				champion.x = -230
				champion.isVisible = true
				transition.to( champion, { time=1000, x=130, iterations=1, transition=easing.inOutElastic } )
			else

				local paint = {
				    type = "image",
				    filename = "images/icons/interrogation.png"
				}
				champion.fill = paint	
				champion.height = 140
				champion.width = 160
				champion.isVisible = true

	    	end 
	    end
	end

	function selectChampionCompEvent(event)

		if scrollView == nil then
			selectChampionDialog()
		else
			group.isVisible = true
			scrollView.isVisible = true
		end
		champion.isVisible = false
		
	end
	champion:addEventListener( "tap", selectChampionCompEvent )
	screenGroup:insert( champion, false )

	function createStrongChampions()
		local strong = display.newText( screenGroup, translations["composition.strong"][language], 35, 230, "fonts/zombie.ttf", "13" )
		strong:setFillColor( 52/255, 152/255, 219/255 )

		if jsonStrong == nil then
			for i=1, 5 do

				local circleStrong = display.newCircle( -400, 200 + (50 * i), 100 )
			
				local paint = {
				    type = "image",
				    filename = "images/icons/interrogation.png",
				    --baseDir = system.TemporaryDirectory
				}
				circleStrong.fill = paint	
				circleStrong.x = circleStrong.x - 5
				circleStrong.y = circleStrong.y - 5

				circleStrong.height = 40
				circleStrong.width = 50
				circleStrong:setFillColor( 255, 255, 255 )
				screenGroup:insert( circleStrong, false )

				transition.to( circleStrong, { time=4000, x=40, iterations=1, transition=easing.inOutElastic } )

			end
		else
			if jsonStrong.forte ~= nil then 
				local listForte = json.decode(jsonStrong.forte)
				for k,v in pairs(listForte) do

					if k <= 5 then
						local circleStrong = display.newCircle( -540, 200 + (50 * k), 100 )
						screenGroup:insert( circleStrong, false )
						downloadCompositonPhoto(v, circleStrong)
						transition.to( circleStrong, { time=2000, x=40, iterations=1, transition=easing.inOutElastic } )
					end

				end
			else
				for i=1, 5 do

					local circleStrong = display.newCircle( -400, 220 + (50 * i), 100 )
				
					local paint = {
					    type = "image",
					    filename = "images/icons/interrogation.png",
					    --baseDir = system.TemporaryDirectory
					}
					circleStrong.fill = paint	
					circleStrong.x = circleStrong.x - 5
					circleStrong.y = circleStrong.y - 5

					circleStrong.height = 40
					circleStrong.width = 50
					circleStrong:setFillColor( 255, 255, 255 )
					screenGroup:insert( circleStrong, false )

					transition.to( circleStrong, { time=4000, x=40, iterations=1, transition=easing.inOutElastic } )

				end
			end
		end

	end

	function createLeakChampions()
		local leak = display.newText( screenGroup, translations["composition.weak"][language], 160, 230, "fonts/zombie.ttf", "13" )
		leak:setFillColor( 231/255, 76/255, 60/255)
	

		if jsonStrong == nil then
			for i=1, 5 do

				local circleLeak = display.newCircle( -570, 200 + (50 * i), 100 )

				local paint = {
				    type = "image",
				    filename = "images/icons/interrogation.png",
				    --baseDir = system.TemporaryDirectory
				}
				circleLeak.fill = paint	
				circleLeak.x = circleLeak.x - 5
				circleLeak.y = circleLeak.y - 5

				circleLeak.height = 40
				circleLeak.width = 50
				circleLeak:setFillColor( 255, 255, 255 )
				screenGroup:insert( circleLeak, false )

				transition.to( circleLeak, { time=4000, x=170, iterations=1, transition=easing.inOutElastic } )

			end
		else
			if jsonStrong.fraco ~= nil then
				local listFraco = json.decode(jsonStrong.fraco)
				for k,v in pairs(listFraco) do

					if k <= 5 then
						local circleLeak = display.newCircle( -570, 200 + (50 * k), 100 )
						screenGroup:insert( circleLeak, false )
						downloadCompositonPhoto(v, circleLeak)
						transition.to( circleLeak, { time=2000, x=170, iterations=1, transition=easing.inOutElastic } )
					end

				end
			else
				for i=1, 5 do

					local circleLeak = display.newCircle( -570, 200 + (50 * i), 100 )

					local paint = {
					    type = "image",
					    filename = "images/icons/interrogation.png",
					    --baseDir = system.TemporaryDirectory
					}
					circleLeak.fill = paint	
					circleLeak.x = circleLeak.x - 5
					circleLeak.y = circleLeak.y - 5

					circleLeak.height = 40
					circleLeak.width = 50
					circleLeak:setFillColor( 255, 255, 255 )
					screenGroup:insert( circleLeak, false )

					transition.to( circleLeak, { time=4000, x=170, iterations=1, transition=easing.inOutElastic } )

				end
			end
		end

	end

	function createTogetherChampions()
		local together = display.newText( screenGroup, translations["composition.together"][language], 270, 230, "fonts/zombie.ttf", "13" )
		together:setFillColor( 39/255, 174/255, 96/255 )


		if jsonStrong == nil then
			for i=1, 5 do

				local circleTogether = display.newCircle( -300, 200 + (50 * i), 100 )

				local paint = {
				    type = "image",
				    filename = "images/icons/interrogation.png",
				    --baseDir = system.TemporaryDirectory
				}
				circleTogether.fill = paint	
				circleTogether.x = circleTogether.x - 3
				circleTogether.y = circleTogether.y - 3

				circleTogether.height = 40
				circleTogether.width = 50
				circleTogether:setFillColor( 255, 255, 255 )
				screenGroup:insert( circleTogether, false )

				transition.to( circleTogether, { time=4000, x=300, iterations=1, transition=easing.inOutElastic } )

			end
		else
			if jsonStrong.bemJunto ~= nil then
				local listTogether = json.decode(jsonStrong.bemJunto)
				for k,v in pairs(listTogether) do

					if k <= 5 then
						local circleTogether = display.newCircle( -300, 200 + (50 * k), 100 )
						screenGroup:insert( circleTogether, false )
						downloadCompositonPhoto(v, circleTogether)
						transition.to( circleTogether, { time=2000, x=300, iterations=1, transition=easing.inOutElastic } )
					end

				end
			else
				for i=1, 5 do

				local circleTogether = display.newCircle( -300, 200 + (50 * i), 100 )

				local paint = {
				    type = "image",
				    filename = "images/icons/interrogation.png",
				    --baseDir = system.TemporaryDirectory
				}
				circleTogether.fill = paint	
				circleTogether.x = circleTogether.x - 3
				circleTogether.y = circleTogether.y - 3

				circleTogether.height = 40
				circleTogether.width = 50
				circleTogether:setFillColor( 255, 255, 255 )
				screenGroup:insert( circleTogether, false )

				transition.to( circleTogether, { time=4000, x=300, iterations=1, transition=easing.inOutElastic } )

			end
			end
		end

	end
	
	networkListenerCompositionImage = function( component, imageName )

		return function(event)
        	if event.isError then
		        print ( "Network error - download failed" )
			
			elseif event.phase == "ended" then
					
				if event.response.fullPath ~= nil then

					local paint = {
					    type = "image",
					    filename = imageName,
					    baseDir = system.TemporaryDirectory
					}
					component.fill = paint	
				else
					local paint = {
					    type = "image",
					    filename = "images/icons/interrogation.png"
					}
					component.fill = paint	
					

				end 

				component.height = 35
				component.width = 45
				component:setFillColor( 255, 255, 255 )
				component.isVisible = true
				screenGroup:insert( component )

			end
        end

	end


	function downloadCompositonPhoto(idChampion, component)
		local photoLink =  services.championImageLocal..idChampion..".png"
		local imageName = "imagem_"..idChampion..".png"
		local params = {}
		params.progress = "download"
		params.response = {
			filename = imageName,
	  		baseDirectory = system.TemporaryDirectory
		}
		network.request( photoLink, "GET", networkListenerCompositionImage(component, imageName),  params )
	end



	function backButtonEvent(event)
		if  "ended" == event.phase then
			
		transition.to( screenGroup, { time=750,  x=-500, iterations=1, transition=easing.inOutElastic, onComplete = function() 
																														globals:removeDialog()
																														storyboard.removeAll()
																														storyboard.gotoScene("login", "fade", 1000)
																													end} )
		end
	end
	

	btnBack = widget.newButton(   
		{
	        label = translations["composition.back"][language],
	        emboss = false,
	        width = 200,
	        height = 30,
	        x = display.contentCenterX - 100,
	        y = display.contentCenterY + 200,
	        defaultFile = "images/button_1.png",
	        fontSize = 12,
	     	labelColor = { default={1,1,1} },
	     	onEvent = backButtonEvent
	    }
	   
	)

	screenGroup:insert( btnBack, false )

	function selectChampionDialog()

		group = display.newGroup()
		
		local dialog = display.newImageRect( "images/dialog1.png", 350, 600)	
		dialog.x = 30
		dialog.y  = display.contentCenterY - 300
		group:insert(dialog, false)

		local textTitle = display.newText( group, translations["composition.selectchampion"][language], 60, 130, "fonts/zombie.ttf", 22 )
		textTitle:setFillColor( 1, 1, 1 )
		group:insert( textTitle )

		local textAguarde = display.newText( group, translations["composition.wait"][language], 60, 180, native.systemFont, 22 )
		textAguarde:setFillColor( 1, 1, 1 )
		group:insert( textAguarde )

		local progressView = widget.newProgressView
				{
				    x = 60,
				    y = 230,
				    width = 200,
					isAnimated = true,
				    fillOuterHeight = 0

				}


		local progress = 0

		function progressBar()
			progress = progress + 0.1
			progressView:setProgress( progress )
			if progress > 0.9 then
				progress = -0.1

			end
		end
		timer.performWithDelay( 100, progressBar, -1 )

		group:insert(progressView)


		scrollView = widget.newScrollView
		{
			top = display.contentCenterY - 130,
	    	left = -5,
		    width = 350,
		    height = 300,
		    hideBackground = true,
		    horizontalScrollDisabled = true
		}

		scrollView.isVisible = false

		group:insert( scrollView )


		function networkCodeListener(event)
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
						local codes = json.decode( decoded.codes )
						local horizontal = 0
						local altura = 1

						for v,k in pairs(codes) do

							horizontal = horizontal + 1
							
							local imageTemp = "champion_"..k..".png"

							local championOption = display.newCircle( 60*horizontal, altura, 100 )
							championOption.isVisible = false
							local function selectChampionEvent(event)
								
								group.isVisible = false
								champion.isVisible = true
								local paint = {
								    type = "image",
								    filename = imageTemp,
								    baseDir = system.TemporaryDirectory
								    --filename = "images/icons/interrogation.png"
								}
								champion.fill = paint

								function networkCompositionListener(event)
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
												
												jsonStrong = decoded
												createStrongChampions()
												createLeakChampions()
												createTogetherChampions()
											end
										end
								    end
								end

								network.request(services.composition..k, "GET", networkCompositionListener, params)


							end
							championOption:addEventListener( "tap",  selectChampionEvent)
							

							if (horizontal % 5)	== 0 then
								altura = (altura+50)
								horizontal = 0
							end

							local function networkListenerChampionImage( event )

							  if event.isError then
							        print ( "Network error - download failed" )
								
							  elseif event.phase == "ended" then
							  		
							    	if event.response.fullPath ~= nil then
										local paint = {
										    type = "image",
										    filename = imageTemp,
										    baseDir = system.TemporaryDirectory
										    --filename = "images/icons/interrogation.png"
										}
										championOption.fill = paint	
									else
										local paint = {
										    type = "image",
										    filename = "images/icons/interrogation.png"
										}
										championOption.fill = paint	

							    	end 

							    	championOption.height = 40
									championOption.width = 50
									championOption:setFillColor( 255, 255, 255 )
									championOption.isVisible = true
									scrollView:insert( championOption, false )

							    	
							    end
							end

							local function downloadChampionPhoto(idChampion)
								local photoLink =  services.championImageLocal..idChampion..".png"
					
								local params = {}
								params.progress = "download"
								params.response = {
									filename = imageTemp,
							  		baseDirectory = system.TemporaryDirectory
								}
								network.request( photoLink, "GET", networkListenerChampionImage,  params )
							end

							downloadChampionPhoto(k)
							
			
						end

						timer.performWithDelay( 1000, 	function() 
																progressView.isVisible = false
																scrollView.isVisible = true
																textAguarde.isVisible = false
															end )
						

					end
				end
		    end
		end
		local params = {}
		network.request(services.listChampionsCodes, "GET", networkCodeListener, params)	


	end

	createStrongChampions()
	createLeakChampions()
	createTogetherChampions()
	
end
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view	
	globals:dialogCompositionInfo()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	--local group = self.view	
	

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

