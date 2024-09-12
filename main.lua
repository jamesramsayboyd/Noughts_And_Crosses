-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Flag for game active/over
game_over = false

-- Keeps track of players' turns, increments by 1 each time fill_cell() is called
turn = 0

-- Flag for player/computer taking first turn
player_first = true

-- Player tokens (i.e. X or O)
player_1_token = "X"
computer_token = "O"

-- Flag for Easy/Hard game mode
easy_mode = true

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

-- Table representing all possible three-in-a-row connections
three_cell_connections = {
    {1, 2, 3},
    {1, 4, 7},
    {1, 5, 9},
    {2, 4, 8},
    {3, 6, 9},
    {3, 5, 6},
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

-- Uses two_cell_connections table to identify any two-in-a-row connections and add them to a table
local function identify_two_in_a_row(token)
    for i = 1, 9 do
        for k, v in pairs(two_cell_connections[i]) do
            if (board[i][7] == token and board[v][7] == token) then
                print("Two " .. token .. "s in a row: cell " .. i .. " and cell " .. v)
                table.insert(two_in_a_rows, {i, v, token})
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
            break
        end
    end
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
    image = token .. ".png"
    r = display.newImage(image)
    r.xScale = 3
    r.yScale = 3
    r.x = board[cell][3] + (w20 / 2)
    r.y = board[cell][6] + (h20 / 2)

    log_move_to_console(token, cell)

    -- Mark cell as filled
    board[cell][7] = token
    turn = turn + 1
    
    identify_two_in_a_row(token)
    identify_three_in_a_row(token)
    check_for_game_over()
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
                -- TODO: Make the computer wait a second so its move doesn't appear instantly
                fill_cell(cell, computer_token)
                break
            end
        end
    end
end


local function complete_two_in_a_row(token)
    print("Completing two in a row")
end

local function create_two_lines_of_two(token)
    print("Creating two lines of two")
end

-- Fills the opposite corner cell
local function fill_opposite_corner(cell, token)
    if cell == 1 then
        fill_cell(9, token)
    else if cell == 3 then
        fill_cell(7, token)
    else if cell == 7 then
        fill_cell(3, token)
    else if cell == 9 then
        fill_cell(1, token)
    end
end


-- OPPONENT'S TURN (HARD MODE, COMPUTER FOLLOWS RULES)
-- Not yet implemented
local function hard_opponent_move ()
    -- LOGIC IN PSEUDOCODE:
    -- If any player has two in a row, play the remaining square
    if table.maxn(two_in_a_rows) > 0 then
        complete_two_in_a_row(computer_token)
    -- Else if you can create two lines of two, play that move
    else if (true)
        create_two_lines_of_two(computer_token)
    -- Else if centre is free (i.e. cell 5), play there
    else if board[5][7] == 0 then
        fill_cell(5, computer_token)
    -- Else if player 1 has played in a corner, play opposite corner
    else if (board[1][7] == player_1_token or board[3][7] == player_1_token or board[7][7] == player_1_token or board[9][7] == player_1_token)
        fill_opposite_corner(1, computer_token) -- TODO: Do this in a loop, send appropriate index to function
    -- Else if there is a free corner, play there
    else if (board[1][7] == 0 or board[3][7] == 0 or board[7][7] == 0 or board[9][7] == 0)
        fill_cell(1, computer_token)
    -- Else, play any empty square
    else
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
                            fill_cell (t, player_1_token)
                            easy_opponent_move()
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