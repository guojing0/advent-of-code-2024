# frozen_string_literal: true

# File processing

problem_input = File.readlines('aoc7.txt', chomp: true)

test_vals, input_numbers = problem_input.map do |line|
  key, value = line.split(': ')
  [key.to_i, value.split.map(&:to_i)]
end.transpose

# First problem

def solve_first_subproblem(test_val, input_num, index, current_result)
  return current_result == test_val if index == input_num.length

  return false if current_result > test_val

  next_num = input_num[index]

  return true if solve_first_subproblem(test_val, input_num, index + 1, current_result + next_num)
  return true if solve_first_subproblem(test_val, input_num, index + 1, current_result * next_num)

  false
end

def solve_first_problem(test_vals, input_nums)
  test_vals.each_with_index.sum do |test_val, idx|
    solve_first_subproblem(test_val, input_nums[idx], 1, input_nums[idx][0]) ? test_val : 0
  end
end

p solve_first_problem(test_vals, input_numbers)

# Second problem

def concat_nums(x, y)
  x * (10**(Math.log10(y).floor + 1)) + y
end

def solve_second_subproblem(test_val, input_num, index, current_result)
  return current_result == test_val if index == input_num.length

  return false if current_result > test_val

  next_num = input_num[index]

  return true if solve_second_subproblem(test_val, input_num, index + 1, concat_nums(current_result, next_num))
  return true if solve_second_subproblem(test_val, input_num, index + 1, current_result + next_num)
  return true if solve_second_subproblem(test_val, input_num, index + 1, current_result * next_num)

  false
end

def solve_second_problem(test_vals, input_nums)
  test_vals.each_with_index.sum do |test_val, idx|
    solve_second_subproblem(test_val, input_nums[idx], 1, input_nums[idx][0]) ? test_val : 0
  end
end

p solve_second_problem(test_vals, input_numbers)
