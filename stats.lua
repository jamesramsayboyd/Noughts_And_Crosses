-----------------------------------------------------------------------------------------
--
-- stats.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()
composer.removeScene( "title" )
print("removing title scene")

local widget = require( "widget" )

-- Variables for screen position
d = display
centre = d.contentWidth / 2
quarter_width = d.contentWidth / 4
new_game_button_y = d.contentHeight / 4
view_stats_button_y = d.contentHeight / 4 * 3

-- Function to handle Back to Title button press
local function handleBackToTitleButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Back to Title button pressed" )
        composer.removeScene( "stats" )
        composer.gotoScene( "title" )
    end
end

-- Button for View Stats
local button_back_to_title = widget.newButton(
    {
        id = "button_back_to_title",
        label = "BACK TO TITLE",
        onEvent = handleBackToTitleButtonEvent,
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









return scene