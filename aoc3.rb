# File processing

all_programs = File.readlines("aoc3.txt", chomp: true)

# Problem 1

def extract_valid_mults(line)
  line.scan(/mul\(\d+,\d+\)/)
end

def sum_of_mults(expressions)
  expressions.sum do |expr|
    numbers = expr.scan(/\d+/).map(&:to_i)
    numbers[0] * numbers[1]
  end
end

total_sum = all_programs.sum do |line|
  valid_mults = extract_valid_mults(line)
  sum_of_mults(valid_mults)
end

puts total_sum

# Problem 2

def extract_valid_mults_with_does(line)
    line.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/)
end

def remove_after_dont!(instr_arr)
    result = []
    should_add = true

    instr_arr.each do |expr|
        if expr == "do()"
            should_add = true
        elsif expr == "don't()"
            should_add = false
        elsif should_add
            result << expr
        end
    end

    result
end

# updated_total_sum = all_programs.join.sum do |line|
#     valid_instr = extract_valid_mults_with_does(line)
#     sum_of_mults(remove_after_dont!(valid_instr))
# end

# puts updated_total_sum

# all_programs.each do |line|
#     valid_instr = extract_valid_mults_with_does(line)
#     print remove_after_dont!(valid_instr)
# end


puts sum_of_mults(remove_after_dont!(extract_valid_mults_with_does(all_programs.join)))
