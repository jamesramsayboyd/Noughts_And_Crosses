-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require("lunatest") --import the test framework
require("game")
require("tests.mytests") -- import the tests and run them

local composer = require( "composer" )

composer.gotoScene( "title" )