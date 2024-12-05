# File processing

input = File.readlines('aoc5.txt', chomp: true)

rules, updates = input.partition { |line| line.include?('|') }

rules = rules.map { |rule| rule.split('|').map(&:to_i) }
updates = updates.reject(&:empty?).map { |update| update.split(',').map(&:to_i) }

# Problem 1

def valid_update?(update, rules)
  update.each_cons(2).all? { |page_pair| rules.include?(page_pair) }
end

def sum_of_middle_numbers(updates)
  updates.sum { |update| update[update.length / 2] }
end

valid_updates = updates.select { |update| valid_update?(update, rules) }

puts sum_of_middle_numbers(valid_updates)

# Problem 2

# inefficient solution
#
# def make_valid_update!(update, rules)
#   changed = true
#
#   while changed
#     changed = false
#     (0...update.length - 1).each do |index|
#       page_pair = [update[index], update[index + 1]]
#
#       if rules.include?(page_pair.reverse)
#         update[index], update[index + 1] = page_pair.reverse
#         changed = true
#       end
#     end
#   end
#
#   update
# end

# solution based on sorting

def valid_comparator(rules)
  lambda do |x, y|
    if rules.include?([x, y]) # x comes before y
      -1
    elsif rules.include?([y, x])
      1
    else
      0
    end
  end
end

invalid_updates = updates - valid_updates
after_valid_updates = invalid_updates.map { |update| update.sort(&valid_comparator(rules))  }

puts sum_of_middle_numbers(after_valid_updates)
