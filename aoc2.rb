# File processing

all_reports = File.readlines("aoc2.txt", chomp: true).map { |line| line.split.map(&:to_i) }

# Helper functions

def sorted?(arr)
    arr.each_cons(2).all? { |x, y| x <= y } ||
    arr.each_cons(2).all? { |x, y| x >= y }
end

def well_ordered?(arr)
    arr.each_cons(2).all? { |x, y| (x - y).abs.between?(1, 3) }
end

def valid_report?(report)
    sorted?(report) && well_ordered?(report)
end

# Problem 1

valid_reports = all_reports.select { |arr| valid_report?(arr) }
valid_count = valid_reports.count

puts valid_count

# Problem 2

invalid_reports = all_reports - valid_reports

may_valid_count = 0

invalid_reports.each do |report|
    valid_after_removal = false

    report.each_with_index do |_, i|
        trunc_report = report[0...i] + report[i+1..-1]

        if valid_report?(trunc_report)
            valid_after_removal = true
            break
        end
    end

    may_valid_count += 1 if valid_after_removal
end

puts may_valid_count + valid_count
