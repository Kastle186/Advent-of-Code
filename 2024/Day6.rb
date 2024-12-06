#!/usr/bin/env ruby

require 'set'

def main(args)
  input_file = args[0]

  # SETUP!

  # Making a pseudo-enum of the 4 different directions here :)
  directions = {
    "NORTH" => [-1, 0],
    "EAST" => [0, 1],
    "SOUTH" => [1, 0],
    "WEST" => [0, -1]
  }

  lab_grid = File.readlines(input_file, chomp: true)
  guard_pt = find_start_point(lab_grid)
  spaces_visited = Set.new
  curr_direction = "NORTH"

  # PART ONE

  while true
    # Add this space to the list of visiteds if we haven't already.

    spaces_visited.add?(guard_pt)

    # Test if the next point is the guard's way out.

    next_pt = add_points(guard_pt, directions[curr_direction])
    unless is_in_grid(next_pt, lab_grid) then break end

    # If not, then test if it is an obstacle. If yes, then change to the next
    # direction. If not, then step forward.

    if lab_grid[next_pt[0]][next_pt[1]] == '#'
      curr_direction = next_direction(curr_direction)
    else
      guard_pt = next_pt
    end
  end

  puts "PART ONE: #{spaces_visited.size}"
end

# HELPER FUNCTIONS!

def find_start_point(grid)
  for i in (0...grid.length)
    row = grid[i]
    for j in (0...row.length)
      return [i, j] if row[j] == '^'
    end
  end
end

def add_points(point_a, point_b)
  [point_a[0] + point_b[0], point_a[1] + point_b[1]]
end

def is_in_grid(point, grid)
  (point[0] >= 0 and point[0] < grid.length) and
    (point[1] >= 0 and point[1] < grid[0].length)
end

def next_direction(current)
  nextd = ""

  case current
  when "NORTH" then nextd = "EAST"
  when "EAST" then nextd = "SOUTH"
  when "SOUTH" then nextd = "WEST"
  when "WEST" then nextd = "NORTH"
  end

  nextd
end

main(ARGV)
