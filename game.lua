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
require("title")

-- Flag for game active/over
game_over = false

-- Keeps track of players' turns, increments by 1 each time fill_cell() is called
turn = 0

-- Variables for game settings
-- easy_mode = true
-- player_1_token = "O"
-- computer_token = "X"
-- player_first = true

-- Table to keep track of game moves so player can undo a move or replay a game
-- Not yet implemented
game_moves = {}

d = display
w20 = d.contentWidth * .2
h20 = d.contentHeight * .2 
w40 = d.contentWidth * .4
h40 = d.contentHeight * .4
w60 = d.contentWidth * .6
h60 = d.contentHeight * .6
w80 = d.contentWidth * .8
h80 = d.contentHeight * .8


----DRAW LINES FOR BOARD
local lline = d.newLine(w40,h20,w40,h80 )
lline.strokeWidth = 5

local rline = d.newLine(w60,h20,w60,h80 )
rline.strokeWidth = 5

local bline = d.newLine(w20,h40,w80,h40 )
bline.strokeWidth = 5

local tline = d.newLine(w20,h60,w80,h60 )
tline.strokeWidth = 5

local function reset_game()
    for i in 1, 9 do
        board[i][7] = 0
    end
end

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

-- Table representing cells at the corners of the board, used in Hard Mode logic
corner_cells = {
    {1, 9},
    {3, 7},
    {7, 3},
    {9, 1}
}

-- corner_cells = {1, 3, 7, 9}

-- Table representing all possible instances of two-in-a-row connections
-- Usage: Numbers in connected_cells[i] are other board cells that touch board[i]
two_cell_connections = {
    {2, 4, 5}, -- 1 is connected to 2, 4 and 5
    {1, 3, 5}, -- 2 is connected etc
    {2, 5, 6}, -- 3
    {1, 5, 7}, -- 4
    {2, 4, 6, 8}, -- 5
    {3, 5, 9}, -- 6
    {4, 5, 8}, -- 7
    {5, 7, 9}, -- 8
    {5, 6, 8} -- 9
}

-- Keeps track of two-in-a-row connections as they are made during a game
two_in_a_rows = {}

-- Table representing all possible instances of two-rows-of-two connections
two_rows_of_two_connections = {
    {1, 2, 4, 5},
    {2, 3, 5, 6},
    {4, 5, 7, 8},
    {5, 6, 8, 9}
}

-- Keeps track of two-rows-of-two connections as they are made during a game
two_rows_of_twos = {}

-- Table representing all possible three-in-a-row connections
three_cell_connections = {
    {1, 2, 3},
    {1, 4, 7},
    {1, 5, 9},
    {2, 5, 8},
    {3, 6, 9},
    {3, 5, 7},
    {4, 5, 6},
    {7, 8, 9}
}

-- Allows player to choose to play as X or O
-- Not yet implemented
local function set_player_tokens()
    if true then
        player_1_token = "O"
        computer_token = "X"
    else
        player_1_token = "X"
        computer_token = "O"
    end
end

-- Identifies winner
local function identify_winner(token)
    if token == player_1_token then
        print("Player 1 wins!")
    else
        print("Computer wins!")
    end
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
    r.xScale = 3
    r.yScale = 3
    r.x = board[cell][3] + (w20 / 2)
    r.y = board[cell][6] + (h20 / 2)

    log_move_to_console(token, cell)

    -- Mark cell as filled
    if (board[cell][7] == 0) then
        board[cell][7] = token
        turn = turn + 1
    end
    
    -- identify_two_in_a_row(token)
    identify_three_in_a_row(token)
    check_for_game_over()
end

-- Fills the opposite corner cell
local function fill_opposite_corner(cell, token)
    for i = 1, 4 do
        if cell == corner_cells[i][1] and board[corner_cells[i][2]][7] == 0 then
            fill_cell(corner_cells[i][2], token)
        end
    end

end

-- Table representing all possible combos leading to a three-in-a-row
-- Extremely amateurish, I'm not happy with this at all, but it's the best idea I have right now
two_in_a_row_combinations = {
    {1, 2, 3},
    {1, 3, 2},
    {1, 5, 9},
    {1, 9, 5},
    {1, 4, 7},
    {1, 7, 4},
    {2, 5, 8},
    {2, 8, 5},
    {3, 5, 7},
    {3, 7, 5},
    {3, 6, 9},
    {3, 9, 6},
    {4, 5, 6},
    {4, 6, 5},
    {5, 1, 9},
    {5, 2, 8},
    {5, 3, 7},
    {5, 7, 3},
    {5, 8, 2},
    {5, 9, 1},
    {6, 5, 4},
    {6, 4, 5},
    {6, 3, 9},
    {6, 9, 3},
    {7, 4, 1},
    {7, 1, 4},
    {7, 5, 3},
    {7, 3, 5},
    {7, 8, 9},
    {7, 9, 8},
    {8, 5, 2},
    {8, 2, 5},
    {9, 8, 7},
    {9, 7, 8},
    {9, 5, 1},
    {9, 1, 5},
    {9, 6, 3},
    {9, 3, 6}
}

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
                print("Free cell = " .. cell)
                -- TODO: Make the computer wait a second so its move doesn't appear instantly
                -- fill_cell(cell, computer_token)
                print("timer.performwithdelay")
                timer.performWithDelay(5000, fill_cell(cell, computer_token))
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
                            print("t = " .. t)
                            fill_cell (t, player_1_token)
                            -- easy_opponent_move()
                            hard_opponent_move(t)                            
                        end
                    end
                end
            end
        else
            print("Game is finished")
        end
    end
end

Runtime:addEventListener("touch", fill)

return scene