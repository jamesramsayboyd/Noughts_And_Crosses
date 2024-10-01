-----------------------------------------------------------------------------------------
--
-- tables.lua
-- Tables representing various combinations of board cells, used in game logic
-----------------------------------------------------------------------------------------

-- Table representing cells at the corners of the board, used in Hard Mode logic
corner_cells = {
    {1, 9},
    {3, 7},
    {7, 3},
    {9, 1}
}

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