
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local translations = require("translations")

local globals = {}

local xCenter = display.contentCenterX
local yCenter = display.contentCenterY
local w = display.contentWidth
local h = display.contentHeight
local language = system.getPreference( "locale", "language" ) 

function globals:showDialog(msg, showButton)

	
	group = display.newGroup()
	group.y = -500

	local dialog = display.newImageRect( "images/dialog1.png", 350, 250)	
	dialog.x = 25
	dialog.y  = yCenter - 250
	group:insert(dialog, false)


	local msgText = display.newText( msg, group.width/6, 120, "", 18 )
	msgText.align = "center"
	msgText:setFillColor(1,1,1)
	msgText.alpha = 0.8
	group:insert(msgText, false)

	progressView = widget.newProgressView
					{

					    x = display.contentCenterX-80,
					    y = display.contentCenterY-80,
					    width = 200,
 					    isAnimated = true,
					    fillOuterHeight = 0
					}
	if showButton then 
		progressView.isVisible = false
	else
		progressView.isVisible = true
	
	end	

	group:insert(progressView, false)

	local progress = 0

	function progressBar()
		progress = progress + 0.1
		progressView:setProgress( progress )
		if progress > 0.9 then
			progress = -0.1

		end
	end

	display.setDefault( "background", 0, 0, 0 )
	timer.performWithDelay( 100, progressBar, -1 )

	local function handleButtonEvent (event)

		if event.phase == "ended" then

			globals:removeDialog()
			storyboard.removeAll()
			storyboard.gotoScene("splash")

		end

	end


	if showButton then
		local btnOk = widget.newButton(
			{
		        label = "Ok",
		        emboss = false,
		        width = 100,
		        height = 30,
		        x = xCenter - 50,
		        y = yCenter - 85,
		        defaultFile = "images/button_1.png",
		        fontSize = 12,
		     	labelColor = { default={1,1,1} },
		        onEvent = handleButtonEvent
	    	}
		)
		btnOk:addEventListener( "tap", btnOk )

		function btnOk:tap(event)
			globals:removeDialog()
		end

		group:insert( btnOk, false)
	end

	transition.to( group, { time=1000, y=display.contentCenterY-200, iterations=1, transition=easing.inOutElastic } )


end

function globals:showDialogNoRedirect(msg, showButton)

	group = display.newGroup()
	group.y = -500

	-- local glass = display.newRect( group, 0, -100, display.contentWidth, display.contentHeight+100 )
	-- glass.alpha = 0.4
	-- glass:setFillColor(0,0,0)

	local dialog = display.newImageRect( "images/dialog1.png", 350, 250)	
	dialog.x = 25
	dialog.y  = yCenter - 250
	group:insert(dialog, false)


	local msgText = display.newText( msg, group.width/6, 120, "", 18 )
	msgText.align = "center"
	msgText:setFillColor(1,1,1)
	msgText.alpha = 0.8
	group:insert(msgText, false)

	progressView = widget.newProgressView
					{

					    x = display.contentCenterX-80,
					    y = display.contentCenterY-100,
					    width = 200,
 					    isAnimated = true,
					    fillOuterHeight = 0
					}
	if showButton then 
		progressView.isVisible = false
	else
		progressView.isVisible = true
	
	end	

	group:insert(progressView, false)

	local progress = 0

	function progressBar()
		progress = progress + 0.1
		progressView:setProgress( progress )
		if progress > 0.9 then
			progress = -0.1

		end
	end

	display.setDefault( "background", 0, 0, 0 )
	timer.performWithDelay( 100, progressBar, -1 )


	if showButton then
		local btnOk = widget.newButton(
			{
		        label = "Ok",
		        emboss = false,
		        width = 100,
		        height = 30,
		        x = xCenter - 50,
		        y = yCenter - 85,
		        defaultFile = "images/button_1.png",
		        fontSize = 12,
		     	labelColor = { default={1,1,1} }
	    	}
		)
		btnOk:addEventListener( "tap", btnOk )

		function btnOk:tap(event)
			globals:removeDialog()
		end

		group:insert( btnOk, false)
	end

	transition.to( group, { time=1000, y=display.contentCenterY-200, iterations=1, transition=easing.inOutElastic } )


end

function globals:showDialogError(msg, showButton, screenDest)

	group = display.newGroup()
	group.y = -500

	-- local glass = display.newRect( group, 0, -100, display.contentWidth, display.contentHeight+100 )
	-- glass.alpha = 0.4
	-- glass:setFillColor(0,0,0)


	local dialog = display.newImageRect( "images/dialog1.png", 350, 250)	
	dialog.x = 25
	dialog.y  = yCenter - 250
	group:insert(dialog, false)


	local msgText = display.newText( msg, group.width/6, 120, "", 18 )
	msgText.align = "center"
	msgText:setFillColor(1,1,1)
	msgText.alpha = 0.8
	group:insert(msgText, false)

	progressView = widget.newProgressView
					{

					    x = display.contentCenterX-80,
					    y = display.contentCenterY-100,
					    width = 200,
 					    isAnimated = true,
					    fillOuterHeight = 0
					}
	if showButton then 
		progressView.isVisible = false
	else
		progressView.isVisible = true
	
	end	

	group:insert(progressView, false)

	local progress = 0

	function progressBar()
		progress = progress + 0.1
		progressView:setProgress( progress )
		if progress > 0.9 then
			progress = -0.1

		end
	end

	display.setDefault( "background", 0, 0, 0 )
	timer.performWithDelay( 100, progressBar, -1 )

	local function handleButtonEventOk (event)

		if event.phase == "ended" then
			storyboard.gotoScene( "login", "fade", 250)

			storyboard.removeAll()

			globals:removeDialog()

		end

	end

	local function handleButtonEventGo (event)

		if event.phase == "ended" then
			storyboard.gotoScene( screenDest, "fade", 250)

			storyboard.removeAll()

			globals:removeDialog()

		end

	end


	if showButton then
		local btnOk = widget.newButton(
			{
		        label = translations["globals.back"][language],
		        emboss = false,
		        width = 100,
		        height = 30,
		        x = xCenter - 120,
		        y = yCenter - 85,
		        defaultFile = "images/button_1.png",
		        fontSize = 12,
		     	labelColor = { default={1,1,1} },
		        onEvent = handleButtonEventOk
	    	}
		)
		group:insert( btnOk, false)
	end

	if screenDest ~= nil then

		local btnGo = widget.newButton(
			{
		        label = translations["globals.go"][language],
		        emboss = false,
		        width = 100,
		        height = 30,
		        x = xCenter + 10,
		        y = yCenter - 85,
		        defaultFile = "images/button_1.png",
		        fontSize = 12,
		     	labelColor = { default={1,1,1} },
		        onEvent = handleButtonEventGo
	    	}
		)
		btnGo:addEventListener( "tap", btnGo )


		group:insert( btnGo, false)

	end

	transition.to( group, { time=1000, y=display.contentCenterY-200, iterations=1, transition=easing.inOutElastic } )


end

function globals:dialogServers(services, btnServer, groupLogin) 

	retorno = "BR"
	group = display.newGroup()
	group.y = -500

	-- local glass = display.newRect( group, 0, -100, display.contentWidth, display.contentHeight+100 )
	-- glass.alpha = 0.4
	-- glass:setFillColor(0,0,0)

	local dialog = display.newImageRect( "images/dialog2.png", 350, 250)	
	dialog.x = 25
	dialog.y  = yCenter - 300
	group:insert(dialog, false)

	local columnData = 
	{ 
	    { 
	        align = "left",
	        startIndex = 1,
	        labels = {"BR", "EUNE", "EUW", "JP", "KR", "LAN", "LAS", "NA", "OCE", "TR", "RU", "PBE" }

	    },
	}

	function valueSeleted(event)
		retorno = columnData[event.column].labels[event.row]
	end

	local picker = widget.newPickerWheel( {

		width = 150,
        height = 10,
        x = xCenter - 70,
	    y = yCenter - 250,
	    columns = columnData,
	    style = "resizable",
	    columnColor = { 1, 1, 1 },
	    rowHeight = 25,
	    fontSize = 14,
	    onValueSelected = valueSeleted

	} )

	group:insert(picker)

	local btnOk = widget.newButton(
		{
	        label = "Ok",
	        emboss = false,
	        width = 100,
	        height = 30,
	        x = xCenter - 50,
	        y = yCenter - 125,
	        defaultFile = "images/button_1.png",
	        fontSize = 12,
	     	labelColor = { default={1,1,1} },
	        onEvent = handleButtonEvent
    	}
	)
	btnOk:addEventListener( "tap", btnOk )

	function btnOk:tap(event)
		services.serverName = retorno
		services:setServerService()
		btnServer:setLabel(retorno)
		globals:removeDialog()
		
		transition.to( groupLogin, { time=1000, y=display.contentCenterY-300, iterations=1, transition=easing.inOutElastic } )
		
		
	end

	group:insert( btnOk, false)

	transition.to( group, { time=1000, y=display.contentCenterY-200, iterations=1, transition=easing.inOutElastic } )
	

end

function globals:dialogCompositionInfo()

	local screenPercent = display.pixelWidth/display.pixelHeight
	local labelSize = 0
	if screenPercent >= 0.75 then
		labelSize = 12
	else
		labelSize = 16
	end

	group = display.newGroup( )
	local dialog = display.newImageRect( "images/dialog1.png", 350, 600)	
	dialog.x = 30
	dialog.y  =  -1000
	group:insert(dialog, false)

	local txt = translations["globals.dialog.info"][language]

	local textDialog = display.newText( group, txt, 60, -880, native.systemFont, labelSize )
	textDialog:setFillColor( 1, 1, 1 )

	local function closeButtonEvent(event)
		globals:removeDialog()
	end
	local btnClose = widget.newButton(
		{
	        label = translations["globals.close"][language],
	        emboss = false,
	        width = 100,
	        height = 30,
	        x = xCenter - 50,
	        y = -560,
	        defaultFile = "images/button_1.png",
	        fontSize = 12,
	     	labelColor = { default={1,1,1} },
	        onEvent = closeButtonEvent
    	}
	)
	group:insert( btnClose )

	transition.to( group, { time=4000, y=1000, iterations=1, transition=easing.inOutElastic } )

end


function globals:removeDialog()
	-- local moveEnd = function(obj)
	--group:removeSelf()
	-- end	
	transition.to( group, { time=1000, y=-500, iterations=1, transition=easing.inOutElastic } )

end

function globals:circleAnimed(group, valuePerCent, scale, r, g ,b, x, y)

	tick = 0
	local calculateValue = (360 * valuePerCent)/100

	local function drawTick(e)
	    local dg = display.newGroup();
	    group:insert( dg )
	    local t = display.newRect(dg, 2, -20, 3, 3);

	    dg.x = x
	    dg.y = y
	    dg:scale(scale, scale)

	    t:setFillColor(r, g, b)
	    dg:rotate(tick-1)

	    if tick < calculateValue then
	        tick = tick + 1
	        timer.performWithDelay(-0.5, drawTick);
	    end
	end
	timer.performWithDelay(0, drawTick);

end


return globals
