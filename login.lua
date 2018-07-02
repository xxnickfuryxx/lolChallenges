
---------------------------------------------------------------------------------
-- Intro Screen 
---------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
system.setIdleTimer( false ) 

local globals = require( "globals" )
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local services = require( "services" )
-- local startapp = require( "plugin.startapp" )
local inMobi = require( "plugin.inMobi" )
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

function scene:createScene( event )
	local screenGroup = self.view
	widget.setTheme( "widget_theme_ios7" )

	services:setServerService()

	local xCenter = display.contentCenterX
	local yCenter = display.contentCenterY
	local w = display.contentWidth
	local h = display.contentHeight

	local backgroungLogin = display.newImage( screenGroup, "images/background_login.png", 0, 0, false)
	backgroungLogin.width = w
	backgroungLogin.height = h

	group = display.newGroup()
	group.isVisible = true

	local dialogLogin = display.newImage("images/login.png", 25, 30)
	dialogLogin:scale( 0.8, 0.8 )
	group:insert( dialogLogin, false )


	local screenPercent = display.pixelWidth/display.pixelHeight
	local labelSize = 0
	if screenPercent >= 0.75 then
		labelSize = 12
	else
		labelSize = 16
	end

	local text = translations["login.intro"][language]

	local textResume = display.newText(text, xCenter-100, yCenter-192)							
	textResume:setFillColor(0.2)
	textResume.size = labelSize
	group:insert( textResume, false )

	function counterButtonEvent(event)
		if  "ended" == event.phase then
			storyboard.removeAll()
			storyboard.gotoScene("composition")
			transition.to( group, { time=1500,  y=-600, iterations=1, transition=easing.inOutElastic, onComplete= function() group.isVisible = false end} )
		end
	end

	btnComposition = widget.newButton(   
		{
	        label = translations["login.composition"][language],
	        emboss = false,
	        width = 200,
	        height = 30,
	        x = xCenter - 100,
	        y = yCenter + 35,
	        defaultFile = "images/button_1.png",
	        fontSize = 12,
	     	labelColor = { default={1,1,1} },
	     	onEvent = counterButtonEvent
	    }
	   
	)
	
	group:insert( btnComposition, false )

	local textSummoner = display.newText(translations["login.summoner"][language], xCenter-100, yCenter+68, native.systemFontBold  )
	textSummoner:setFillColor(0.5)
	textSummoner.size = 16
	group:insert( textSummoner, false )
	
	local rectange = display.newRect( xCenter-100, yCenter+90, 200, 30 )
	rectange.strokeWidth = 2
	rectange:setFillColor( 1,1,1 )
	rectange:setStrokeColor( 0, 0, 0 )
	group:insert( rectange, false )

	local txtSummoner = native.newTextField( xCenter-100, yCenter+90, 200, 30 )
	txtSummoner.align = "center"
	txtSummoner.hasBackground = false
	--txtSummoner.text = "RiotSchmick"
	txtSummoner:setReturnKey("done")
	group:insert( txtSummoner, false )
	
	local function textListenerEvent(event)
		if event.phase == "began" then
			group.y = group.y - 100
		elseif event.phase == "ended" then
			group.y = group.y + 100
		end
	end
	txtSummoner:addEventListener( "userInput", textListenerEvent )

	local function onClickTextServer (event) 
		if event.phase == "ended" then
			transition.to( group, { time=750, y=-600, iterations=1, transition=easing.inOutElastic } )
			globals:dialogServers(services, btnServer, group)
		end
	end

	if services.serverName == nil then
		btnServer = widget.newButton(   
			{
		        label = translations["login.server"][language],
		        emboss = false,
		        width = 200,
		        height = 30,
		        x = xCenter - 100,
		        y = yCenter + 130,
		        defaultFile = "images/button_1.png",
		        fontSize = 12,
		     	labelColor = { default={1,1,1} },
		     	onEvent = onClickTextServer
		    }
		)
	else
		btnServer = widget.newButton(   
			{
		        label =services.serverName,
		        emboss = false,
		        width = 200,
		        height = 30,
		        x = xCenter-100,
		        y = yCenter + 130,
		        defaultFile = "images/button_1.png",
		        fontSize = 12,
		     	labelColor = { default={1,1,1} },
		     	onEvent = onClickTextServer
		    }
		)
	end

	
	group:insert( btnServer, false )


	local function handleButtonEvent( event )

	    if  "ended" == event.phase then
	        if (txtSummoner.text ~= nil and txtSummoner.text ~= "" and btnServer.label ~= "SERVER" and services.url ~= nil) then

	        	native.setKeyboardFocus( nil )
	        	transition.to( group, { time=750, y=-600, iterations=1, transition=easing.inOutElastic, onComplete=function() group.isVisible = false end } )
	        	
				txtSummoner.isVisible = false
				globals:showDialog(txtSummoner.text..(translations["login.wait"][language]), false)
				backgroungLogin.fill.effect = "filter.blurGaussian"
 
				backgroungLogin.fill.effect.horizontal.blurSize = 20
				backgroungLogin.fill.effect.horizontal.sigma = 140
				backgroungLogin.fill.effect.vertical.blurSize = 20
				backgroungLogin.fill.effect.vertical.sigma = 140

				services:callService(services.summonerByName..txtSummoner.text, "game")

			else
				transition.to( group, { time=750, y=-600, iterations=1, transition=easing.inOutElastic } )
				globals:showDialogError(translations["login.erro.connect"][language], true)
			end
	    end
	end

	btnEntrar = widget.newButton(   
		{
	        label = translations["login.search"][language],
	        emboss = false,
	        width = 200,
	        height = 30,
	        x = xCenter - 100,
	        y = yCenter + 170,
	        defaultFile = "images/button_1.png",
	        fontSize = 12,
	     	labelColor = { default={1,1,1} },
	     	onEvent = handleButtonEvent
	    }
	   
	)
	
	group:insert( btnEntrar, false )




	group.y = -600

	local function textListener( event )
 
	    if ( event.phase == "ended" or event.phase == "submitted" ) then
	        native.setKeyboardFocus(nil)
	    end

	end
	txtSummoner:addEventListener( "userInput", textListener )
	transition.to( group, { time=2000, y=display.contentCenterY-300, iterations=1, transition=easing.inOutElastic } )





	-- StartApp listener function
	-- local function adListener( event )
 --    	 if ( event.phase == "init" ) then  -- Successful initialization
	--         startapp.load( "interstitial" )
	--     elseif ( event.phase == "loaded" ) then  -- The ad was successfully loaded
	--     elseif ( event.phase == "failed" ) then  -- The ad failed to load
	--     end
	-- end
 
	-- startapp.init( adListener, { appId="202880689" } )
	-- startapp.show( "banner" , {adTag = "LOL Challenges bottom banner",
	-- 							yAlign = "bottom",
	-- 							bannerType = "standard" })




	-- INMOD 
	local placementID
	if system.getInfo( "manufacturer" ) ==  "Apple" then
		placementID = "1531137747747" --ios
	else
		placementID = "1531510351639" --android
	end

	local function adListener( event )
	    if ( event.phase == "init" ) then  -- Successful initialization
	        inMobi.load( "banner", placementID )

	    elseif ( event.phase == "failed" ) then  -- The ad failed to load
	        print( event.type )
	        print( event.placementId )
	        print( event.isError )
	        print( event.response )

	        native.showAlert( "Error", event.response, {"OK"} )
    
	    end
	end
	-- Initialize the InMobi plugin
	inMobi.init( adListener, { accountId="4719d581ff664522ab7a9842dcd89866", hasUserConsent=true } )
	inMobi.show( placementID, { yAlign="bottom" } )

	
end
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view	

	

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	--local group = self.view	
	group.y = 0

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

