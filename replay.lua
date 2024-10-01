-----------------------------------------------------------------------------------------
--
-- replay.lua
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

-- Function to handle Back to Title button press
local function handleBackToStatsButtonEvent( event )
    if ( "ended" == event.phase ) then
        print( "Back to Title button pressed" )
        composer.removeScene( "replay" )
        composer.gotoScene( "stats" )
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
    -- Stats page title (STATS)
    local replay_title = display.newText("REPLAY LAST GAME", centre, MARGIN, FONT, TITLE_TEXT_SIZE)
    sceneGroup:insert(replay_title)

    -- Get stats data from stats.txt
    -- local stats_table = readStats()

    -- Loop through stats data printing to screen and adding each line to sceneGroup
    -- for k, v in pairs(stats_table) do
    --     print("k = " .. k .. ", v = " .. v)
    --     local stat_line = display.newText(v, centre, 50 + 25 * k, FONT, STATS_TEXT_SIZE)
    --     sceneGroup:insert(stat_line)
    -- end

    -- Button for Back to Stats
    local button_back_to_stats = widget.newButton(
        {
            id = "button_back_to_stats",
            label = "BACK TO STATS",
            onEvent = handleBackToStatsButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 180,
            height = 50,
            cornerRadius = 2,
            labelColor = { default = white, over = white },
            fillColor = { default = black, over = grey }, 
            strokeColor = { default = white, over = white },
            strokeWidth = 4,
            x = centre,
            y = lowest_button_y
        }
    )
    sceneGroup:insert(button_back_to_stats)
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