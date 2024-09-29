-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

local widget = require( "widget" )

FONT = "Arial"
TITLE_TEXT_SIZE = 27
LABEL_TEXT_SIZE = 20
MARGIN = 30

-- Variables for game settings, passed to game.lua
easy_mode = true
player_1_token = "O"
computer_token = "X"
player_first = true

-- Variables for screen position
d = display
centre = d.contentWidth / 2
quarter_width = d.contentWidth / 4
switch_y = d.contentHeight / 7
start_game_button_y = d.contentHeight / 5 * 3.7
view_stats_button_y = d.contentHeight - MARGIN

-- Colours for buttons, sliders
black = {0, 0, 0, 1}
grey = {0.66, 0.66, 0.66, 1}
white = {1, 1, 1, 1}

-- Handle press events for difficulty switch
local function onDifficultySwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
    if switch.isOn then
        easy_mode = true
        print("Difficulty switched to Easy Mode, easy_mode boolean = " .. tostring(easy_mode))
    else
        easy_mode = false
        print("Difficulty switched to Hard Mode, easy_mode boolean = " .. tostring(easy_mode))
    end
end

-- Handle press events for difficulty switch
local function onPlayerTokenSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
    if switch.isOn then
        player_1_token = "O"
        computer_token = "X"
        print("Player 1 token = " .. player_1_token .. ", computer token = " .. computer_token)
    else
        player_1_token = "X"
        computer_token = "O"
        print("Player 1 token = " .. player_1_token .. ", computer token = " .. computer_token)
    end
end

-- Handle press events for play order switch
local function onPlayOrderSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
    if switch.isOn then
        player_first = true
        print("Player 1 goes first, player_first boolean = " .. tostring(player_first))
    else
        player_first = false
        print("Computer goes first, player_first boolean = " .. tostring(player_first))
    end
end

-- Function to handle Start Game button press
local function handleStartGameButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Start Game button pressed" )
        composer.gotoScene( "game" )
    end
end

-- Function to handle New Game (Hard) button press
local function handleViewStatsButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "View Stats button pressed" )
        -- composer.hide()
        -- print("Removing title scene")
        composer.gotoScene( "stats" )
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view

    -- App title (NOUGHTS & CROSSES)
    local app_title = display.newText("NOUGHTS & CROSSES", centre, MARGIN, FONT, TITLE_TEXT_SIZE)
    sceneGroup:insert(app_title)

    -- Difficulty switch label and options
    local difficulty_switch_label = display.newText("DIFFICULTY", centre, switch_y * 2 - 31, FONT, LABEL_TEXT_SIZE)
    sceneGroup:insert(difficulty_switch_label)
    local difficulty_switch_options = display.newText("  EASY               HARD", centre, switch_y * 2, FONT, LABEL_TEXT_SIZE)
    sceneGroup:insert(difficulty_switch_options)

    -- Player token switch label and options
    local player_token_switch_label = display.newText("PLAYER TOKEN", centre, switch_y * 3 - 31, FONT, LABEL_TEXT_SIZE)
    sceneGroup:insert(player_token_switch_label)
    local player_token_switch_options = display.newText(" O               X", centre, switch_y * 3, FONT, LABEL_TEXT_SIZE)
    sceneGroup:insert(player_token_switch_options)

    -- First turn switch label and options
    local play_order_switch_label = display.newText("FIRST TURN", centre, switch_y * 4 - 31, FONT, LABEL_TEXT_SIZE)
    sceneGroup:insert(play_order_switch_label)
    local play_order_switch_options = display.newText("    PLAYER 1              COMPUTER", centre, switch_y * 4, FONT, LABEL_TEXT_SIZE)
    sceneGroup:insert(play_order_switch_options)

    -- Switch for Easy Mode/Hard Mode selection
    local difficulty_switch = widget.newSwitch(
        {
            left = 250,
            top = 200,
            style = "onOff",
            id = "difficulty_switch",
            x = centre,
            y = switch_y * 2,
            onPress = onDifficultySwitchPress
        }
    )
    sceneGroup:insert(difficulty_switch)

    -- Switch for Player token choice, O or X
    local player_token_switch = widget.newSwitch(
        {
            left = 250,
            top = 200,
            style = "onOff",
            id = "player_token_switch",
            x = centre,
            y = switch_y * 3,
            onPress = onPlayerTokenSwitchPress
        }
    )
    sceneGroup:insert(player_token_switch)

     -- Switch for Player First/Computer First selection
     local play_order_switch = widget.newSwitch(
        {
            left = 250,
            top = 200,
            style = "onOff",
            id = "play_order_switch",
            x = centre,
            y = switch_y * 4,
            onPress = onPlayOrderSwitchPress
        }
    )
    sceneGroup:insert(play_order_switch)

    -- Button for Start Game
    local button_start_game = widget.newButton(
        {
            id = "button_start_game",
            label = "START GAME",
            onEvent = handleStartGameButtonEvent,
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
            y = start_game_button_y
        }
    )
    sceneGroup:insert(button_start_game)

    -- Button for View Stats
    local button_view_stats = widget.newButton(
        {
            id = "button_view_stats",
            label = "VIEW STATS",
            onEvent = handleViewStatsButtonEvent,
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
            y = view_stats_button_y
        }
    )
    sceneGroup:insert(button_view_stats)
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
        composer.removeScene("title")
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