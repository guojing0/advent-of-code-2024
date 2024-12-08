# frozen_string_literal: true

# File processing

input = File.readlines('aoc8.txt', chomp: true).map { |line| line.split('')}

# First problem

def within_bounds?(pt, row_size, col_size)
  pt[0].between?(0, row_size - 1) && pt[1].between?(0, col_size - 1)
end

def list_add(fst_pt, snd_pt)
  fst_pt.zip(snd_pt).map { |x, y| x + y }
end

def list_diff(fst_pt, snd_pt)
  fst_pt.zip(snd_pt).map { |x, y| x - y }
end

def slope(fst_pt, snd_pt)
  x1, y1 = fst_pt
  x2, y2 = snd_pt

  (y2 - y1).to_r / (x2 - x1)
end

def digit_or_letter?(char)
  char.match?(/[a-zA-Z]/) || char.match?(/\d/)
end

def collect_antennas(input)
  antenna_symbols = []

  input.each do |line|
    antenna_symbols << line.select { |x| digit_or_letter?(x) }
  end

  antenna_symbols.flatten.uniq
end

def locate_antennas(matrix, ant_symbol)
  antennas = []
  matrix.each_with_index do |row, row_index|
    col_index = row.index(ant_symbol)
    antennas << [row_index, col_index] if col_index
  end

  antennas
end

def solve_first_problem(matrix)
  ant_symbols = collect_antennas(matrix)
  antenna_positions = ant_symbols.map { |ant| locate_antennas(matrix, ant) }

  antinodes = Set.new

  antenna_positions.each do |ant_pos|
    ant_pos.combination(2) do |x, y|
      abs_diff = list_diff(x, y).map(&:abs)

      if slope(x, y).positive?
        antinodes << list_diff(x, abs_diff)
        antinodes << list_add(y, abs_diff)
      else
        antinodes << [x[0] - abs_diff[0], x[1] + abs_diff[1]]
        antinodes << [y[0] + abs_diff[0], y[1] - abs_diff[1]]
      end
    end
  end

  # Clean out-of-boundary
  antinodes.select! { |node| within_bounds?(node, matrix.length, matrix[0].length) }

  antinodes.size
end

p solve_first_problem(input)

# Problem 2

# def solve_second_problem(matrix)
#   ant_symbols = collect_antennas(matrix)
#   antenna_positions = ant_symbols.map { |ant| locate_antennas(matrix, ant) }
#
#   antinodes = Set.new
#
#   antenna_positions.each do |ant_pos|
#     ant_pos.combination(2) do |x, y|
#       abs_diff = list_diff(x, y).map(&:abs)
#
#       if slope(x, y).positive?
#         (1..matrix.size).each do |i|
#           antinodes << list_diff(x, abs_diff * i).map { |n| n % 50 }
#           antinodes << list_add(y, abs_diff * i).map { |n| n % 50 }
#         end
#       else
#         (1..matrix.size).each do |i|
#           antinodes << [x[0] - abs_diff[0] * i, x[1] + abs_diff[1] * i].map { |n| n % 50 }
#           antinodes << [y[0] + abs_diff[0] * i, y[1] - abs_diff[1] * i].map { |n| n % 50 }
#         end
#       end
#     end
#   end
#
#   # Clean out-of-boundary
#   antinodes.select! { |node| within_bounds?(node, matrix.length, matrix[0].length) }
#
#   antinodes.size
# end
#
# p solve_second_problem(input)

# Problem 2

def solve_second_problem(matrix)
  ant_symbols = collect_antennas(matrix)
  antenna_positions = ant_symbols.map { |ant| locate_antennas(matrix, ant) }

  antinodes = Set.new

  antenna_positions.each do |ant_pos|
    # Add all antenna positions to antinodes since they are valid locations
    antinodes.merge(ant_pos)

    # Compute all valid antinodes from pairs of antennas
    ant_pos.combination(2) do |x, y|
      diff = list_diff(x, y)

      # Compute the direction vector and normalize to avoid overlapping steps
      step = diff.map { |d| d.zero? ? 0 : d / d.abs }

      # Generate points in both directions
      current = x.dup
      while within_bounds?(current, matrix.length, matrix[0].length)
        antinodes << current.dup
        current = list_diff(current, step)
      end

      current = y.dup
      while within_bounds?(current, matrix.length, matrix[0].length)
        antinodes << current.dup
        current = list_add(current, step)
      end
    end
  end

  # Count unique antinodes within bounds
  antinodes.size
end

p solve_second_problem(input)

