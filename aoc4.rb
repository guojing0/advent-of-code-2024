# File processing

input = File.readlines('aoc4.txt', chomp: true)

# Helper functions

def count_pattern_in_arrays(input, pattern)
  input.sum do |line|
    line.scan(/#{pattern}/).count + line.reverse.scan(/#{pattern}/).count
  end
end

def count_in_arrays(input)
  count_pattern_in_arrays(input, 'XMAS')
end

def collect_diagonals(matrix)
  rows = matrix.size
  cols = matrix[0].size
  diagonals = []

  # Helper to collect a diagonal starting at (start_row, start_col) with direction (dr, dc)
  collect_diagonal = lambda do |start_row, start_col, dr, dc|
    diagonal = []
    row = start_row
    col = start_col
    while row.between?(0, rows - 1) && col.between?(0, cols - 1)
      diagonal << matrix[row][col]
      row += dr
      col += dc
    end
    diagonals << diagonal if diagonal.size >= 4
  end

  # Collect all primary diagonals (top-left to bottom-right)
  (0...rows).each { |row| collect_diagonal.call(row, 0, 1, 1) } # Start from left edge
  (1...cols).each { |col| collect_diagonal.call(0, col, 1, 1) } # Start from top edge

  # Collect all secondary diagonals (top-right to bottom-left)
  (0...rows).each { |row| collect_diagonal.call(row, cols - 1, 1, -1) } # Start from right edge
  (0...(cols - 1)).each { |col| collect_diagonal.call(0, col, 1, -1) }  # Start from top edge

  diagonals
end

# Problem 1

alias count_in_rows count_in_arrays

def count_in_columns(input)
  transposed_input = input.map(&:chars).transpose.map(&:join)
  count_in_arrays(transposed_input)
end

def count_in_diagonals(input)
  count_in_arrays(collect_diagonals(input).map(&:join))
end

def count_all(input)
  count_in_rows(input) + count_in_columns(input) + count_in_diagonals(input)
end

puts count_all(input)

# Problem 2

def collect_x_diagonal(matrix, i, j)
  diagonals = []

  diagonals << [matrix[i - 1][j - 1], matrix[i][j], matrix[i + 1][j + 1]]
  diagonals << [matrix[i - 1][j + 1], matrix[i][j], matrix[i + 1][j - 1]]

  diagonals
end

def count_valid_x_diagonals(input)
  input_matrix = input.map(&:chars)
  rows = input.size
  columns = input[0].size

  (1...rows - 1).sum do |i|
    (1...columns - 1).count do |j|
      current_x_diagonal = collect_x_diagonal(input_matrix, i, j).map(&:join)

      input_matrix[i][j] == 'A' &&
        count_pattern_in_arrays(current_x_diagonal, 'MAS') == 2
    end
  end
end

puts count_valid_x_diagonals(input)
