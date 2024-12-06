# frozen_string_literal: true

# File processing

problem_input = File.readlines('aoc6.txt', chomp: true).map(&:chars)

# Problem 1

def leave_map?(matrix, i, j)
  i.zero? || j.zero? || i == matrix.size - 1 || j == matrix[0].size - 1
end

def solve_problem(maze, start_i, start_j)
  i, j = start_i, start_j
  distinct_visits = 0

  directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
  current_dir_idx = 0

  until leave_map?(maze, i, j)
    di, dj = directions[current_dir_idx]
    next_i, next_j = i + di, j + dj

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

def find_guard(matrix)
  matrix.each_with_index do |row, row_index|
    col_index = row.index('^')
    return [row_index, col_index] if col_index
  end

  raise 'Guard not found in the input'
end

caret_index = find_guard(problem_input)

puts solve_problem(problem_input, *caret_index)
