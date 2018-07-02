---------------------------------------------------------------------------------
-- Intro Screen 
---------------------------------------------------------------------------------
local storyboard = require( "storyboard" )
local widget = require( "widget" )
local globals = require( "globals" )

local scene = storyboard.newScene()

display.setDefault( "anchorX", 0.0 )    -- default to TopLeft anchor point for new objects
display.setDefault( "anchorY", 0.0 )


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local text
local progressView

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	storyboard.removeAll()

	text1 = display.newText( screenGroup, "A", display.contentCenterX-10, display.contentCenterY-80, "fonts/zombie.ttf", 40 )
	text2 = display.newText( screenGroup, "xxnickfuryxx", display.contentCenterX/3, display.contentCenterY-50, "fonts/zombie.ttf", 40 )
	text3 = display.newText( screenGroup, "production", display.contentCenterX-100, display.contentCenterY-20, "fonts/zombie.ttf", 40 )

	progressView = widget.newProgressView
					{
					    x = display.contentCenterX-80,
					    y = display.contentCenterY,
					    width = 200,
 					    isAnimated = true,
					    fillOuterHeight = 0
					}

	progressView.isVisible = false
	--progressView.rotation = 90

	local x = 1
	local y = 1

	function moveText()
		text1.alpha = x
		text2.alpha = x
		text3.alpha = x
		x = x - 0.01 

		if x < 0.0099999999999992 then
			-- local image = display.newImage( screenGroup, "Icon-xxxhdpi.png", display.contentWidth/3, (display.contentHeight/3) -50 )
			local progress = 0
			progressView.isVisible = false

			function progressBar()
				progress = progress + 0.1
				progressView:setProgress( progress )
				if progress > 0.9 then
					progressView.isVisible = false
					storyboard.gotoScene( "login" , "fade", 250)

				end
			end

			display.setDefault( "background", 0, 0, 0 )
			timer.performWithDelay( 1, progressBar, 10 )

		end

	end

	timer.performWithDelay( 20, moveText, 100 )

	
end
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view	
	
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