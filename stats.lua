-----------------------------------------------------------------------------------------
--
-- stats.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )

-- Variables for screen position
d = display
centre = d.contentWidth / 2
quarter_width = d.contentWidth / 4
new_game_button_y = d.contentHeight / 4
view_stats_button_y = d.contentHeight / 4 * 3
clear_stats_button_y = d.contentHeight / 5 * 4
back_to_title_button_y = d.contentHeight - 30

-- Function to read in stats file and display stats of previous games
local function displayStats()
    print("Reading stats file")
    print("Displaying stats")
end

-- Function to handle Back to Title button press
local function handleBackToTitleButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Back to Title button pressed" )
        composer.removeScene( "stats" )
        composer.gotoScene( "title" )
    end
end

-- Function to handle Clear Stats button press
local function handleClearStatsButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Clear Stats button pressed" )
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
    -- 'NOUGHTS & CROSSES' title image
    -- title_image = display.newImage(app_title)
    -- title_image.xScale = 0.15
    -- title_image.yScale = 0.15
    -- title_image.x = centre
    -- title_image.y = 30
    -- sceneGroup:insert(title_image)

    -- Button for View Stats
    local button_clear_stats = widget.newButton(
        {
            id = "button_clear_stats",
            label = "CLEAR STATS",
            onEvent = handleClearStatsButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 150,
            height = 50,
            cornerRadius = 2,
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4,
            x = centre,
            y = clear_stats_button_y
        }
    )
    sceneGroup:insert(button_clear_stats)

    -- Button for View Stats
    local button_back_to_title = widget.newButton(
        {
            id = "button_back_to_title",
            label = "BACK TO TITLE",
            onEvent = handleBackToTitleButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 180,
            height = 50,
            cornerRadius = 2,
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4,
            x = centre,
            y = back_to_title_button_y
        }
    )
    sceneGroup:insert(button_back_to_title)
end

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("stats")
    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------






return scene