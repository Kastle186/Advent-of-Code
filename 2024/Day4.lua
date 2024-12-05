#!/usr/bin/env lua

-- A Lua table playing the role of an Enum :)

Directions = {
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

   local ceres_file = arg[1]
   local ceres_fptr = io.open(ceres_file, "r")
   local ceres_puzzle = {}

   -- Read our input file and store the lines in a list.
   for line in ceres_fptr:lines() do
      table.insert(ceres_puzzle, line)
   end

   local letter_locs = init_letter_locations(ceres_puzzle)
   local result1 = calculate_xmas_count(letter_locs)
end

   -- for k, v in pairs(letter_locs) do
   --    print(k)
   --    for l = 1, #v do
   --       print(v[l][1], v[l][2])
   --    end
   --    print("")
   -- end

-- HELPER FUNCTIONS! --

function init_letter_locations(input_puzzle)
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

function calculate_xmas_count(locs_table)
   local result = 0
   local xs = locs_table.X

   for i = 1, #xs do
      local direction = Direction.NONE
      local next_x_loc = xs[i]
      local num_words = expect_words(locs_table.M, next_x_loc, 'm', direction)

      if num_words > 0 then
         result += num_words
      end
   end

   return result
end

function expect_words(next_letter_locs, src_loc, expected, direction)
   return 0
end

function are_neighbors(point_a, point_b)
end

-- START SCRIPT! --
main()
