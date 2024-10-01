-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local timer = require ( "timer" )

-- Access game settings from title menu
-- require("title")
require("tables")

-- Flag for game active/over
game_over = false

-- Keeps track of players' turns, increments by 1 each time fill_cell() is called
turn = 0

-- Table to keep track of game moves so player can undo a move or replay a game
-- Not yet implemented
game_moves = {}

-- Variables to keep track of last moves for player and computer
-- Used for Undo Last Move button
undo_last_move_possible = false
last_player_move = 1
last_computer_move = 1


d = display
w20 = d.contentWidth * .2
h20 = d.contentHeight * .2 
w40 = d.contentWidth * .4
h40 = d.contentHeight * .4
w60 = d.contentWidth * .6
h60 = d.contentHeight * .6
w80 = d.contentWidth * .8
h80 = d.contentHeight * .8

--PLACE BOARD COMPARTMENT DIMENSIONS IN TABLE
-- Using board[i][7] as marker of whether cell is filled. 0 == not filled, 1 == filled
board ={
    {"top left", 1, w20, h40, w40, h20,0},
    {"top middle",2, w40,h40,w60,h20,0},
    {"top right",3, w60,h40,w80,h20,0},

    {"middle left", 4, w20, h60, w40, h40,0},
    {"middle middle",5, w40,h60,w60,h40,0},
    {"middle right",6, w60,h60,w80,h40,0},

    {"bottom left", 7, w20, h80, w40, h60,0},
    {"bottom middle",8, w40,h80,w60,h60,0},
    {"bottom right",9, w60,h80,w80,h60,0}
}
--

local function reset_game()
    turn = 0
    for i = 1, 9 do
        board[i][7] = 0
    end
end

-- Resets game_stats.txt file when new game begins
local function reset_game_stats_file()
    filepath = system.pathForFile( "last_game.txt", system.DocumentsDirectory )

    local file, errorString = io.open( filepath, "w+")

    if not file then
        -- Error occurred; output the cause
        print("File error: " .. errorString)
    else
        -- Append data to file
        file:write("")
        -- Close the file handle
        io.close(file)
    end
    file = nil
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    reset_game()
    reset_game_stats_file()

    -- Game title (*difficulty* GAME)
    local game_title = display.newText(easy_mode and "EASY GAME" or "HARD GAME", centre, MARGIN, FONT, TITLE_TEXT_SIZE)
    sceneGroup:insert(game_title)

    ----DRAW LINES FOR BOARD
    local lline = d.newLine(w40,h20,w40,h80 )
    lline.strokeWidth = 5
    sceneGroup:insert(lline)

    local rline = d.newLine(w60,h20,w60,h80 )
    rline.strokeWidth = 5
    sceneGroup:insert(rline)

    local bline = d.newLine(w20,h40,w80,h40 )
    bline.strokeWidth = 5
    sceneGroup:insert(bline)

    local tline = d.newLine(w20,h60,w80,h60 )
    tline.strokeWidth = 5
    sceneGroup:insert(tline)

    
    -- Logs winner to stats.txt file
    local function log_game_stats(token)
        date = os.date('%Y-%m-%d %H:%M:%S')
        game_data = ""

        if token == player_1_token then
            game_data = date .. " - Player 1 (" .. token .. ") wins\n"
        elseif token == computer_token then
            game_data = date .. " - Computer (" .. token .. ") wins\n"
        else
            game_data = date .. " - Game drawn\n"
        end

        filepath = system.pathForFile( "stats.txt", system.DocumentsDirectory )

        local file, errorString = io.open( filepath, "a")

        if not file then
            -- Error occurred; output the cause
            print("File error: " .. errorString)
        else
            -- Append data to file
            file:write(game_data)
            -- Close the file handle
            io.close(file)
        end
        file = nil
    end

    -- Logs all moves to last_game.txt file for replay game function
    local function log_move_to_file(token, cell)
        move_description = ""

        if cell == 0 then
            move_description = "\n*Final move* Result = " .. token .. "\n"
        else
            if token == "blank" then
                move_description = "Turn " .. turn .. ": Move undone\n"
            else 
                move_description = "Turn " .. turn ..": " .. token .. " played in cell " .. cell .. "\n"        
            end
        end


        filepath = system.pathForFile( "last_game.txt", system.DocumentsDirectory )

        local file, errorString = io.open( filepath, "a")

        if not file then
            -- Error occurred; output the cause
            print("File error: " .. errorString)
        else
            -- Append data to file
            file:write(move_description)
            -- Close the file handle
            io.close(file)
        end
        file = nil
    end

    -- Display game result
    local function display_game_result(token)
        local result = ""

        if token == player_1_token then
            result = "PLAYER 1 WINS"
        elseif token == computer_token then
            result = "COMPUTER WINS"
        else
            result = "GAME DRAWN"
        end

        local game_result_label = display.newText(result, centre, MARGIN + 35, FONT, LABEL_TEXT_SIZE)
        log_move_to_file(result, 0)
        sceneGroup:insert(game_result_label)
    end



    -- Identifies winner, prints to console
    local function identify_winner(token)
        if token == player_1_token then
            print("Player 1 wins!")
        else
            print("Computer wins!")
        end

        log_game_stats(token)
        display_game_result(token)
    end

    local function identify_two_rows_of_two(token)
        for i = 1, 4 do
            for k, v in pairs(two_rows_of_two_connections[i]) do
                if (board[i][7] == token and board[v][7] == token) then
                    print("Two rows of two found for " .. token .. " in cells " .. v)
                    table.insert(two_rows_of_twos, {i, v, token})
                    break
                end
            end
        end
    end

    -- Uses three_cell_connections table to identify any three-in-a-row connections and end the game
    local function identify_three_in_a_row(token)
        for i = 1, 8 do
            line = three_cell_connections[i]
            if (board[line[1]][7] == token and board[line[2]][7] == token and board[line[3]][7] == token) then
                print("Three cell connection found, " .. token .." wins")
                game_over = true
                identify_winner(token)
                break
            end
        end
    end

    local function identify_opponent_corner_cell(token)
        for i = 1, 4 do
            cell = corner_cells[i][1]
            opposite_cell = corner_cells[i][2]
            if board[cell][7] == token and board[opposite_cell][7] == 0 then
                print("Identify_corner_cell() identifies " .. cell)
                return cell
            end
        end
        return 0
    end

    local function identify_free_corner_cell()
        for i = 1, 4 do
            cell = corner_cells[i][1]
            if board[cell][7] == 0 then
                return cell
            end
        end
        return 0
    end


    -- Checks for game over (max 9 turns)
    local function check_for_game_over()
        if turn > 8 then
            game_over = true
            log_game_stats("draw")
            display_game_result("draw")
            print("Game over")
        end
    end

    -- Logs all moves to the console
    local function log_move_to_console(token, cell)
        print(token .. " placed in " .. board[cell][1] .. " board cell")
    end


    -- Fills a cell with O or X images
    -- Also logs moves to console, increments turn count and checks turn count
    local function fill_cell (cell, token)
        image = "images/" .. token .. ".png"
        r = display.newImage(image)
        r.xScale = 2.5
        r.yScale = 2.5
        r.x = board[cell][3] + (w20 / 2)
        r.y = board[cell][6] + (h20 / 2)
        sceneGroup:insert(r)

        log_move_to_console(token, cell)

        -- Mark cell as filled
        if (board[cell][7] == 0) then
            board[cell][7] = token
            turn = turn + 1
        end
        
        -- identify_two_in_a_row(token)
        identify_three_in_a_row(token)
        check_for_game_over()
        
        -- Update last move trackers so move can be undone
        if token == player_1_token then
            last_player_move = cell
        elseif token == computer_token then
            last_computer_move = cell
        end

        undo_last_move_possible = true
        log_move_to_file(token, cell)
    end

    -- Fills the opposite corner cell
    local function fill_opposite_corner(cell, token)
        for i = 1, 4 do
            if cell == corner_cells[i][1] and board[corner_cells[i][2]][7] == 0 then
                fill_cell(corner_cells[i][2], token)
            end
        end

    end

    -- Uses two_cell_connections table to identify any two-in-a-row connections and add them to a table
    local function identify_two_in_a_row(token)
        -- Get length of two_in_a_row_combinations table:
        local count = 0
        for _ in pairs(two_in_a_row_combinations) do count = count + 1 end

        print("Identifying two-in-a-rows")
        for i = 1, count do
            row = two_in_a_row_combinations[i]
            if (board[row[1]][7] == token and board[row[2]][7] == token) then   -- If first two cells of potential row are filled by player
                if board[row[3]][7] == 0 then                                   -- If last cell is free
                    -- return true
                    print("Two-in-a-row found, cell " .. row[3] .. " should be filled")
                    return row[3]
                end
            end
        end
        print("No incomplete two-in-a-rows found")
    end

    local function identify_two_lines_of_two()
        print("Identifying two rows of two")
        -- empty table
        local two_rows_of_two = {}
        -- loop through potential 2ro2s
        for i = 1, 4 do
            -- table of {1, 2, 4, 5}
            two_rows_of_two = two_rows_of_two_connections[i]
            -- loop through 1, 2, 4, 5
            for j = 1, 4 do
                -- print 1, 2, 4, 5
                print("two_rows_of_two[j] = " .. two_rows_of_two[j])
                -- if cell 1, 2, 4 or 5 is filled or has already been looked at
                if two_rows_of_two[j] ~= 99 then
                    if board[two_rows_of_two[j]][7] ~= 0 then
                        -- forget it
                        two_rows_of_two[j] = 99
                    end
                end
            end
            for x = 1, 4 do
                if two_rows_of_two[x] ~= 99 then
                    if board[two_rows_of_two[x]][7] == 0 then
                        print("two-rows-of-two[x] = " .. two_rows_of_two[x])
                        return two_rows_of_two[x]
                        -- fill_cell(two_row_of_two[i], token)
                    end
                end
            end
        end

        print("Second step of identify_two_lines_of_two")

        for i = 1, 4 do
            print("two_rwos_of_two[i] = " .. two_rows_of_two[i])
            if two_rows_of_two[i] == 0 then
                print("two-rows-of-two[i] = " .. two_rows_of_two[i])
                return two_rows_of_two[i]
                -- fill_cell(two_row_of_two[i], token)
            end
        end

    end

    -- -----------------------------------------------------------------------------------
    -- Easy Mode/Hard Mode computer player logic
    -- -----------------------------------------------------------------------------------
    -- OPPONENT'S TURN (EASY MODE, COMPUTER PLAYS RANDOMLY)
    -- Generate random number, check if that cell is empty
    -- Fill with appropriate image (X or O)
    -- Mark cell filled
    local function easy_opponent_move ()
        if game_over == false then
            while true
            do
                cell = math.random(1,9)
                if board[cell][7] == 0 then
                    print("Easy mode, free cell = " .. cell)
                    -- TODO: Make the computer wait a second so its move doesn't appear instantly
                    fill_cell(cell, computer_token)
                    break
                end
            end
        end
    end


    -- OPPONENT'S TURN (HARD MODE, COMPUTER FOLLOWS RULES)
    local function hard_opponent_move (player_move)
        -- LOGIC TAKEN FROM ASSIGNMENT DOCUMENT:
        -- If any player has two in a row, play the remaining square
        if identify_two_in_a_row(player_1_token) then       -- WORKING
            print("Hard Opponent Move: Two in a row connection found")
            fill_cell(identify_two_in_a_row(player_1_token), computer_token)
        -- -- Else if you can create two lines of two, play that move
        -- elseif identify_two_lines_of_two() ~= 0 then        -- TODO
        --     print("Hard Opponent Move: Two rows of two possible")
        --     fill_cell(identify_two_lines_of_two(), computer_token)
        -- Else if centre is free (i.e. cell 5), play there
        elseif board[5][7] == 0 then      -- WORKING
            print("Hard Opponent Move: Middle cell is free")
            fill_cell(5, computer_token)
        -- Else if player 1 has played in a corner, play opposite corner
        elseif (identify_opponent_corner_cell(player_1_token) ~= 0) then      -- WORKING
            print("Hard Opponent Move: Corner cell filled, playing opposite corner")
            fill_opposite_corner(identify_opponent_corner_cell(player_1_token), computer_token)
        -- Else if there is a free corner, play there
        elseif (identify_free_corner_cell() ~= 0) then      -- WORKING
            print("Hard Opponent Move: Corner cell free")
            fill_cell(identify_free_corner_cell(), computer_token)
        -- Else, play any empty square
        else
            print("Hard Opponent Move: All other options exhausted, playing random square")
            easy_opponent_move()
        end
    end

    --FILL COMPARTMENT W/ COLOUR WHEN TOUCHED
    local function fill (event)
        if event.phase == "began" then
            --tap = 0
            if not game_over then
                for t = 1, 9 do
                    if event.x > board[t][3] and event.x < board [t][5] then
                        if event.y < board[t][4] and event.y > board[t][6] then
                            if board[t][7] == 0 then

                                -- Difficulty conditional
                                fill_cell (t, player_1_token)
                                if easy_mode then
                                    easy_opponent_move()
                                else
                                    hard_opponent_move(t)
                                end

                                -- if player_first then
                                --     fill_cell (t, player_1_token)
                                --     if easy_mode then
                                --         easy_opponent_move()
                                --     else
                                --         hard_opponent_move(t)
                                --     end
                                -- else
                                --     if easy_mode then
                                --         easy_opponent_move()
                                --     else
                                --         hard_opponent_move(t)
                                --     end
                                --     fill_cell (t, player_1_token)
                                -- end
                            end
                        end
                    end
                end
            else
                print("Game is finished")
            end
        end
    end

    -- Function to add and remove Touch event listener when scene is created/destroyed
    function add_touch_event_listener(directive)
        if directive == "add" then
            Runtime:addEventListener("touch", fill)
        elseif directive == "remove" then
            Runtime:removeEventListener("touch", fill)
        end
    end

    -- Activate screen touch event listener (will be manually deactivated when quitting to title)
    add_touch_event_listener("add")

    -- Handles play order
    -- TODO: Make it work
    if not player_first then
        if easy_mode then
            print("computer making first move, easy mode")
            easy_opponent_move()
        else
            print("computer making first move, hard mode")
            fill_cell(5, computer_token)
        end
    end

    
    -- -----------------------------------------------------------------------------------
    -- Event Handlers for buttons:
    -- -----------------------------------------------------------------------------------
    -- Function to handle Undo Last Move button press
    local function handleUndoLastMoveButtonEvent( event ) 
        if ( "ended" == event.phase ) then
            print( "Undo Last Move button pressed" )
            if undo_last_move_possible and not game_over then
                print( "undo_last_move_possible = true")
                print("last_player_move = " .. last_player_move)
                print("last_computer_move = " .. last_computer_move)

                -- Delete O/X.pngs
                fill_cell(last_player_move, "blank")
                turn = turn - 1
                fill_cell(last_computer_move, "blank")
                turn = turn - 1

                -- Clear board table entries to mark board cells free
                board[last_player_move][7] = 0
                board[last_computer_move][7] = 0

                undo_last_move_possible = false
            end
        end
    end

    -- Function to handle Back to Title button press
    local function handleQuitToTitleButtonEvent( event ) 
        if ( "ended" == event.phase ) then
            print( "Quit to Title button pressed" )
            add_touch_event_listener("remove")
            composer.removeScene( "game" )
            composer.gotoScene( "title" )
        end
    end

    -- -----------------------------------------------------------------------------------
    -- Buttons:
    -- -----------------------------------------------------------------------------------
    -- Button for Undo Last Move
    local button_undo_last_move = widget.newButton(
        {
            id = "button_undo_last_move",
            label = "UNDO LAST MOVE",
            onEvent = handleUndoLastMoveButtonEvent,
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
            y = second_lowest_button_y
        }
    )
    sceneGroup:insert(button_undo_last_move)

    -- Button for Quit to Title
    local button_quit_to_title = widget.newButton(
        {
            id = "button_quit_to_title",
            label = "QUIT TO TITLE",
            onEvent = handleQuitToTitleButtonEvent,
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
            -- y = view_stats_button_y + 50
            y = lowest_button_y
        }
    )
    sceneGroup:insert(button_quit_to_title)

end

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        reset_game()

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
    add_touch_event_listener("remove")
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