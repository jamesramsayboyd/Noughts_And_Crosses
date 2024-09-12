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

-- Checks for three in a row
-- Not yet implemented
local function check_for_winner()
    if true then
        game_over = true
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
    board[cell][7] = 1
    turn = turn + 1
    
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

-- OPPONENT'S TURN (HARD MODE, COMPUTER FOLLOWS RULES)
-- Not yet implemented
local function hard_opponent_move (event, t)
    -- Loop through cells to find array of empty ones, i.e. where board[i][7] == 0
    -- Follow given logic to find best cell
    -- Fill with appropriate image (X or O)
    -- Mark cell filled
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