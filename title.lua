-----------------------------------------------------------------------------------------
--
-- title.lua
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

-- Display 'Noughts & Crosses' title png
app_title = "images/title.png"
local title_image
-- title_image = display.newImage(app_title)
-- title_image.xScale = 0.15
-- title_image.yScale = 0.15
-- title_image.x = centre
-- title_image.y = 30

-- Function to handle New Game (Easy) button press
local function handleNewGameEasyButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "New Game (Easy) button pressed" )
    end
end

-- -- Button for New Game (Easy)
-- local button_new_game_easy = widget.newButton(
--     {
--         id = "button_new_game_easy",
--         label = "NEW GAME\n     (EASY)",
--         onEvent = handleNewGameEasyButtonEvent,
--         emboss = false,
--         -- Properties for a rounded rectangle button
--         shape = "roundedRect",
--         width = 120,
--         height = 80,
--         cornerRadius = 2,
--         fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
--         strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
--         strokeWidth = 4,
--         x = quarter_width,
--         y = new_game_button_y
--     }
-- )

-- Function to handle New Game (Hard) button press
local function handleNewGameHardButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "New Game (Hard) button pressed" )
    end
end

-- -- Button for New Game (Hard)
-- local button_new_game_hard = widget.newButton(
--     {
--         id = "button_new_game_easy",
--         label = "NEW GAME\n     (HARD)",
--         onEvent = handleNewGameHardButtonEvent,
--         emboss = false,
--         -- Properties for a rounded rectangle button
--         shape = "roundedRect",
--         width = 120,
--         height = 80,
--         cornerRadius = 2,
--         fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
--         strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
--         strokeWidth = 4,
--         x = quarter_width * 3,
--         y = new_game_button_y
--     }
-- )

-- Function to handle New Game (Hard) button press
local function handleViewStatsButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "View Stats button pressed" )
        -- composer.hide()
        -- print("Removing title scene")
        composer.gotoScene( "stats" )
    end
end

-- -- Button for View Stats
-- local button_view_stats = widget.newButton(
--     {
--         id = "button_view_stats",
--         label = "VIEW STATS",
--         onEvent = handleViewStatsButtonEvent,
--         emboss = false,
--         -- Properties for a rounded rectangle button
--         shape = "roundedRect",
--         width = 120,
--         height = 80,
--         cornerRadius = 2,
--         fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
--         strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
--         strokeWidth = 4,
--         x = centre,
--         y = view_stats_button_y
--     }
-- )





-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
    title_image = display.newImage(app_title)
    title_image.xScale = 0.15
    title_image.yScale = 0.15
    title_image.x = centre
    title_image.y = 30

    -- Button for New Game (Easy)
    local button_new_game_easy = widget.newButton(
        {
            id = "button_new_game_easy",
            label = "NEW GAME\n     (EASY)",
            onEvent = handleNewGameEasyButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 120,
            height = 80,
            cornerRadius = 2,
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4,
            x = quarter_width,
            y = new_game_button_y
        }
    )

    -- Button for New Game (Hard)
    local button_new_game_hard = widget.newButton(
        {
            id = "button_new_game_easy",
            label = "NEW GAME\n     (HARD)",
            onEvent = handleNewGameHardButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 120,
            height = 80,
            cornerRadius = 2,
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4,
            x = quarter_width * 3,
            y = new_game_button_y
        }
    )

    -- Button for View Stats
    local button_view_stats = widget.newButton(
        {
            id = "button_view_stats",
            label = "VIEW STATS",
            onEvent = handleViewStatsButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 120,
            height = 80,
            cornerRadius = 2,
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4,
            x = centre,
            y = view_stats_button_y
        }
    )
	   
    -- insert objects into the scene group
    sceneGroup:insert(title_image, button_new_game_easy, button_new_game_hard, button_view_stats)


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