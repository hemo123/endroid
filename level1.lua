-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local car, leftArrow, rightArrow, street1, street2, street3
local streetInitialPosition
local movingCarDirection

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

local function onLeftArrowTouch( event )
	if event.phase == 'began' then
    	movingCarDirection = "LEFT"
    end

    if event.phase == 'ended' then
    	movingCarDirection = "STOPED"
    end
    return true
end 

local function onRightArrowTouch( event )
	if event.phase == 'began' then
    	movingCarDirection = "RIGHT"
    end
    
    if event.phase == 'ended' then
    	movingCarDirection = "STOPED"
    end
    return true
end 

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	street1 = display.newImageRect( "images/street.png" , 320, 480)
	street1.x = screenW / 2
	street1.y = screenH / 2

	street2 = display.newImageRect( "images/street.png" , 320, 480)
	street2.x = street1.x
	street2.y = street1.y - street2.height

	street3 = display.newImageRect( "images/street.png" , 320, 480)
	street3.x = street1.x
	street3.y = street2.y - street3.height

	streetInitialPosition = street3.y + 10

	car = display.newImageRect( "images/red_car.png", 34, 56)
	car.x = screenW / 2 
	car.y = screenH - 100
	physics.addBody( car, 'static', { density=1.0, friction=0.3, bounce=0.3 } )

	leftArrow = display.newImageRect( "images/left_arrow.png", 60, 30)
	leftArrow.x = 40
	leftArrow.y = screenH - 30

	rightArrow = display.newImageRect( "images/right_arrow.png", 60, 30)
	rightArrow.x = screenW - 40
	rightArrow.y = screenH - 30

	movingCarDirection = "STOPED"
	
	-- -- make a crate (off-screen), position it, and rotate slightly
	-- local crate = display.newImageRect( "crate.png", 90, 90 )
	-- crate.x, crate.y = 160, -100
	-- crate.rotation = 15
	
	-- -- add physics to the crate
	-- physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )
	
	-- -- create a grass object and add physics (with custom shape)
	-- local grass = display.newImageRect( "grass.png", screenW, 82 )
	-- grass:setReferencePoint( display.BottomLeftReferencePoint )
	-- grass.x, grass.y = 0, display.contentHeight
	
	-- -- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	-- local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	-- physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- -- all display objects must be inserted into group
	group:insert( street1 )
	group:insert( street2 )
	group:insert( street3 )
	-- group:insert( crate )
	group:insert( car )
	group:insert( leftArrow )
	group:insert( rightArrow )
	
	leftArrow:addEventListener( "touch", onLeftArrowTouch )
	rightArrow:addEventListener( "touch", onRightArrowTouch )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

local function onEnterFrame( event )
	street1.y = street1.y + 10
	street2.y = street2.y + 10
	street3.y = street3.y + 10

	print(streetInitialPosition)

	if street1.y - 240 > 480 then
		street1.y = streetInitialPosition
	end

	if street2.y - 240 > 480 then
		street2.y = streetInitialPosition
	end

	if street3.y - 240 > 480 then
		street3.y = streetInitialPosition
	end

	local speed = 5

	if movingCarDirection == "RIGHT" then
	  	car.x = car.x + speed
    elseif movingCarDirection == "LEFT" then
    	car.x = car.x - speed
    end
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

Runtime:addEventListener( "enterFrame", onEnterFrame)

-----------------------------------------------------------------------------------------

return scene