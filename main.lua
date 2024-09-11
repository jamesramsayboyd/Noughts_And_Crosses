-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Keeps track of players' turns, increments by 1 each time fill() is called
turn = 1

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

--FILL COMPARTMENT W/ COLOUR WHEN TOUCHED
local function fill (event)
    if event.phase == "began" then
        --tap = 0

        for t = 1, 9 do
        if event.x > board[t][3] and event.x < board [t][5] then
            if event.y < board[t][4] and event.y > board[t][6] then
                if board[t][7] == 0 then
                    -- Mark cell as filled
                    board[t][7] = 1

                    r = d.newRect(board[t][3],board [t][6],w20,h20)
                        r:setFillColor(1,1,0)
                        r.anchorX=0
                        r.anchorY=0
                        
                        -- ***** Week 7 Deliverable ***** (X gets first turn)
                        if turn % 2 == 0 then
                            print("O placed in " .. board[t][1] .. " board cell")
                        else
                            print("X placed in " .. board[t][1] .. " board cell")
                        end
                        turn = turn + 1

                        end
                    end
                end
            end 
        end
    end

Runtime:addEventListener("touch", fill)