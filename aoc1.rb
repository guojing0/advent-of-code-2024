left_list = []
right_list = []

File.foreach("aoc1.txt") do |line|
  left_id, right_id = line.split.map(&:to_i)
  left_list << left_id
  right_list << right_id
end

left_list.sort!
right_list.sort!

# First problem

id_sum = left_list.zip(right_list).sum { |x, y| (x - y).abs }

puts id_sum

# Second problem

sim_score_hash = Hash.new
total_sim_score = 0

# Precompute the counts of elements in `right_list`
right_list_counts = right_list.tally

# Calculate similarity scores and total score
left_list.each do |id|
    count = right_list_counts[id] || 0
    sim_score_hash[id] ||= id * count
    total_sim_score += sim_score_hash[id]
end

puts total_sim_score

### LLM optimizations

# Initialize the total similarity score
total_sim_score = 0

# Precompute the counts of elements in `right_list`
right_list_counts = right_list.tally

# Calculate total similarity score directly
total_sim_score = left_list.uniq.sum do |id|
  count = right_list_counts[id] || 0
  id * count
end

puts total_sim_score
