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

-- -----------------------------------------------------------------------------------
-- File I/O Functions
-- -----------------------------------------------------------------------------------
local filepath = system.pathForFile("stats.txt", system.DocumentsDirectory)
-- local filepath = "files/stats.txt"


-- Function to read game win/loss statistics in from stats.txt file
local function readStats()
    -- Table to store lines from stats.txt file
    local stats_table = {}
    local file, errorString = io.open( filepath, "r" )

    if not file then
        -- Error occurred; output the cause
        print("File error: " .. errorString)
    else
        -- Output lines
        for line in file:lines() do
            table.insert(stats_table, line)
            print(line)
        end
        -- Close the file
        io.close(file)
        
    end

    file = nil
    
    return stats_table
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
        filepath = system.pathForFile( "stats.txt", system.DocumentsDirectory )

        -- Opening file in w+ mode will remove all existing data
        local file, errorString = io.open( filepath, "w+")

        if not file then
            -- Error occurred; output the cause
            print("File error: " .. errorString)
        else
            -- Overwrite all data with blank string
            file:write("")

            -- Refresh scene to display newly deleted data
            composer.removeScene( "stats" )
            composer.gotoScene( "stats" )

            -- Close the file handle
            io.close(file)
        end
        file = nil
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
    local stats_title = display.newText("STATS", centre, MARGIN, FONT, TITLE_TEXT_SIZE)
    sceneGroup:insert(stats_title)

    -- Get stats data from stats.txt
    local stats_table = readStats()

    -- Loop through stats data printing to screen and adding each line to sceneGroup
    for k, v in pairs(stats_table) do
        print("k = " .. k .. ", v = " .. v)
        local stat_line = display.newText(v, centre, 50 + 25 * k, FONT, STATS_TEXT_SIZE)
        sceneGroup:insert(stat_line)
    end

    -- Button for Clear Stats
    local button_clear_stats = widget.newButton(
        {
            id = "button_clear_stats",
            label = "CLEAR STATS",
            onEvent = handleClearStatsButtonEvent,
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
            y = clear_stats_button_y
        }
    )
    sceneGroup:insert(button_clear_stats)

    -- Button for Back to Title
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
            labelColor = { default = white, over = white },
            fillColor = { default = black, over = grey }, 
            strokeColor = { default = white, over = white },
            strokeWidth = 4,
            x = centre,
            y = back_to_title_button_y
        }
    )
    sceneGroup:insert(button_back_to_title)

    readStats()
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