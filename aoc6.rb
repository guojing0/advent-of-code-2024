# frozen_string_literal: true

# File processing

problem_input = File.readlines('aoc6.txt', chomp: true).map(&:chars)

# Helper functions

def leave_map?(matrix, i, j)
  i.zero? || j.zero? || i == matrix.size - 1 || j == matrix[0].size - 1
end

def find_guard(matrix)
  matrix.each_with_index do |row, row_index|
    col_index = row.index('^')
    return [row_index, col_index] if col_index
  end

  raise 'Guard not found in the input'
end

def visited_locations(matrix, start_point)
  visited_locations = []

  matrix.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      next if cell != 'x' # Skip if the cell is not `x`
      next if start_point == [i, j] # Skip the starting point

      visited_locations << [i, j]
    end
  end

  visited_locations
end

# Problem 1

def solve_first_problem(maze, start_point)
  i, j = start_point
  distinct_visits = 0

  directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
  current_dir_idx = 0

  until leave_map?(maze, i, j)
    di, dj = directions[current_dir_idx]
    next_i, next_j = i + di, j + dj

    # If next position is #, then turn clockwise 90 degree
    if maze[next_i][next_j] == '#'
      current_dir_idx = (current_dir_idx + 1) % 4
    else
      unless maze[i][j] == 'x'
        distinct_visits += 1
        maze[i][j] = 'x'
      end

      i, j = next_i, next_j
    end
  end

  distinct_visits + 1
end

gurad_index = find_guard(problem_input)

puts solve_first_problem(problem_input, gurad_index)

# Problem 2

def solve_second_problem(maze, start_point)
  i, j = start_point
  directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
  visited_loc = visited_locations(maze, start_point)
  valid_block_count = 0

  visited_loc.each do |new_obstr|
    # Place the new obstruction
    maze[new_obstr[0]][new_obstr[1]] = '#'

    # Reset guard state
    travel_record = Set.new
    i, j = start_point
    current_dir_idx = 0

    loop_detected = false

    until leave_map?(maze, i, j)
      current_state = [i, j, current_dir_idx]

      if travel_record.include?(current_state)
        loop_detected = true
        break
      end

      travel_record.add(current_state)

      di, dj = directions[current_dir_idx]
      next_i, next_j = i + di, j + dj

      # Turn if next position is an obstruction
      if maze[next_i][next_j] == '#'
        current_dir_idx = (current_dir_idx + 1) % 4
      else
        i, j = next_i, next_j
      end
    end

    # Count valid positions causing a loop
    valid_block_count += 1 if loop_detected

    # Restore the grid
    maze[new_obstr[0]][new_obstr[1]] = '.'
  end

  valid_block_count + 1
end

puts solve_second_problem(problem_input, gurad_index)
