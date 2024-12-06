#!/usr/bin/env lua

-- A Lua table playing the role of an Enum :)

Direction = {
   NONE = 0
   NORTH = 1
   NORTHWEST = 2
   NORTHEAST = 3
   SOUTH = 4
   SOUTHWEST = 5
   SOUTHEAST = 6
   EAST = 7
   WEST = 8
}

function main()
   -- SETUP! --
   local input_file = io.open(arg[1], "r")
   local ceres_puzzle = {}

   -- Read our input file and store the lines in a list.
   for line in input_file:lines() do
      table.insert(ceres_puzzle, line)
   end

   local letter_locs = init_letter_locations(ceres_puzzle)

   -- for k, v in pairs(letter_locs) do
   --    print(k)
   --    for l = 1, #v do
   --       print(v[l][1], v[l][2])
   --    end
   --    print("")
   -- end

   -- PART ONE! --
   local result1 = calculate_xmas_count(letter_locs)
end

-- HELPER FUNCTIONS! --

function init_letter_locations(input_puzzle)
   -- Dictionary that will contain the locations of each letter.
   local letter_locs = {
      X = {},
      M = {},
      A = {},
      S = {}
   }

   for i = 1, #input_puzzle do
      local line = input_puzzle[i]

      for j = 1, #line do
         -- Yes, that's how we get one character at a time in Lua :)
         local ch = line:sub(j,j)
         table.insert(letter_locs[ch], {i, j})
      end
   end

   return letter_locs
end

function calculate_xmas_count(letter_locs)
   local result = 0
   local xs = locs_table.X

   for i = 1, #xs do
      local next_x = xs[i]
      local direction = Direction.NONE
      local num_words = count_words(letter_locs, next_x, 'X', direction)

      if num_words >= 0 then
         result += num_words
      end
   end

   return result
end

function count_words(letter_locs, start, letter, direction)
   if letter == 'S' then return 1 end
end

main()
