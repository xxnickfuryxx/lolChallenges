
---------------------------------------------------------------------------------
-- Intro Screen 
---------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
system.setIdleTimer( false ) 

local globals = require( "globals" )
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local services = require( "services" )
local startapp = require( "plugin.startapp" )

local scene = storyboard.newScene()

storyboard.removeAll()

display.setDefault( "anchorX", 0.0 )    -- default to TopLeft anchor point for new objects
display.setDefault( "anchorY", 0.0 )


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

--storyboard.gotoScene(  "title", "fade", 5000  ) 

-- Called when the scene's view does not exist:
local group

function scene:createScene( event )
	local screenGroup = self.view

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
	dialogLogin:scale( 0.8, 0.7 )
	group:insert( dialogLogin, false )

	local text = "LOL CHALLENGES\n\nisn't endorsed by Riot Games and\n"..
				"doesn't reflect the views or opinions\n"..
				"of Riot Games or anyone officially\n".. 
				"involved in producing or managing \n"..
				"League of Legends.\n\nLeague of Legends\n"..
				"and Riot Games are trademarks \nor registered\n"..
				"trademarks of Riot Games, Inc."

	local textResume = display.newText(text, xCenter-100, yCenter-195)							
	textResume:setFillColor(0.2)
	textResume.size = 14
	group:insert( textResume, false )

	local textSummoner = display.newText("Summoner", xCenter-100, yCenter-20)
	textSummoner:setFillColor(0.5)
	textSummoner.size = 16
	group:insert( textSummoner, false )
	
	local rectange = display.newRect( xCenter-100, yCenter, 200, 30 )
	rectange.strokeWidth = 2
	rectange:setFillColor( 1,1,1 )
	rectange:setStrokeColor( 0, 0, 0 )
	group:insert( rectange, false )

	local txtSummoner = native.newTextField( xCenter-100, yCenter, 200, 30 )
	txtSummoner.align = "center"
	txtSummoner.hasBackground = false
	--txtSummoner.text = "RiotSchmick"
	group:insert( txtSummoner, false )

	native.setKeyboardFocus(txtSummoner)

	local function onClickTextServer (event) 
		if event.phase == "ended" then
			group.y = -1000
			globals:dialogServers(services, btnServer)
		end
	end

	if services.serverName == nil then
		btnServer = widget.newButton(   
			{
		        label = "SERVER",
		        emboss = false,
		        width = 200,
		        height = 30,
		        x = xCenter-100,
		        y = yCenter+40,
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
		        y = yCenter+40,
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

	        	group.isVisible = false
				txtSummoner.isVisible = false
				globals:showDialog(txtSummoner.text.."\n\nWait, search your summoner...", false)
				backgroungLogin.fill.effect = "filter.blurGaussian"
 
				backgroungLogin.fill.effect.horizontal.blurSize = 20
				backgroungLogin.fill.effect.horizontal.sigma = 140
				backgroungLogin.fill.effect.vertical.blurSize = 20
				backgroungLogin.fill.effect.vertical.sigma = 140

				services:callService(services.summonerByName..txtSummoner.text, "game")

			else
				group.y = -1000
				globals:showDialogError("Please, enter the summoner\n and select server to connect.", true)
			end
	    end
	end

	btnEntrar = widget.newButton(   
		{
	        label = "SEARCH",
	        emboss = false,
	        width = 200,
	        height = 30,
	        x = xCenter - 100,
	        y = yCenter + 80,
	        defaultFile = "images/button_1.png",
	        fontSize = 12,
	     	labelColor = { default={1,1,1} },
	     	onEvent = handleButtonEvent
	    }
	)
	
	group:insert( btnEntrar, false )
	group.x = 1000
	transition.moveTo( group, {x=0, time=1000 } )

	-- StartApp listener function
	-- local function adListener( event )
 --    	 if ( event.phase == "init" ) then  -- Successful initialization
	--         startapp.load( "interstitial" )
	--     elseif ( event.phase == "loaded" ) then  -- The ad was successfully loaded
	--     elseif ( event.phase == "failed" ) then  -- The ad failed to load
	--     end
	-- end
 
	-- -- Initialize the StartApp plugin
	-- startapp.init( adListener, { appId="112074675" } )

	-- -- Show banner ad. no need to pre-load banner
	-- startapp.show( "banner" , {adTag = "LOL Challenges bottom banner",
	-- 							yAlign = "bottom",
	-- 							bannerType = "standard" })

	
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
	print("destroiu")
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

