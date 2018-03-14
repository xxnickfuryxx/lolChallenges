
display.setStatusBar(display.HiddenStatusBar)
system.setIdleTimer( false ) 

local storyboard = require( "storyboard" )

	local options = {
	    effect = "slideLeft",
	    time = 800,
	    params = { any="vars", can="go", here=true }	-- optional params table to pass to scene event
	}
	
storyboard.gotoScene("splash", "fade", 1000)

