class Program
  @rules: Array(String)
  @my_ticket: Array(Int32)
  @nearby_tickets: Array(Array(Int32))

  def initialize
    rules, my_ticket, nearby_tickets = File.read("16.txt").chomp.split("\n\n")

    @rules = rules.split('\n')
    @my_ticket = my_ticket.split('\n')[1].split(',').map(&.to_i)
    @nearby_tickets = nearby_tickets.split('\n')[1..-1].map { |ticket| ticket.split(',').map(&.to_i) }
  end

  def get_ranges(rule)
    _, ranges = rule.split(": ")
    ranges.split(" or ").map { |range| range.split("-").map(&.to_i) }
  end

  def part_1
    @nearby_tickets.sum do |ticket|
      ticket.sum do |field|
        valid = false
        @rules.each do |rule|
          get_ranges(rule).each { |(min, max)| valid = true if min <= field && field <= max }
        end
        valid ? 0 : field
      end
    end
  end

  def part_2
    valid_tickets = @nearby_tickets.select do |ticket|
      ticket.all? do |field|
        @rules.any? do |rule|
          get_ranges(rule).any? { |(min, max)| min <= field && field <= max }
        end
      end
    end

    matrix = Array.new(@rules.size) { Array.new(@rules.size) { 1 } }
    valid_tickets.each do |ticket|
      ticket.each_with_index do |field, field_index|
        @rules.each_with_index do |rule, rule_index|
          _, ranges_str = rule.split(": ")
          ranges = ranges_str.split(" or ")
          possible = false
          ranges.each do |range|
            min, max = range.split("-").map(&.to_i)
            possible = true if min <= field && field <= max
          end
          matrix[field_index][rule_index] = 0 if !possible
        end
      end
    end

    while (matrix.sum { |row| row.sum } > @rules.size)
      (0...@rules.size).each do |r|
        if matrix[r].sum == 1
          (0...@rules.size).each do |c|
            (0...@rules.size).each { |i| matrix[i][c] = 0 if i != r } if matrix[r][c] == 1
          end
        end
      end

      (0...@rules.size).each do |c|
        if matrix.sum { |row| row[c] } == 1
          (0...@rules.size).each do |r|
            (0...@rules.size).each { |i| matrix[r][i] = 0 if i != c } if matrix[r][c] == 1
          end
        end
      end
    end

    rule_indexes = (0...@rules.size).select { |idx| @rules[idx].starts_with?("departure") }
    field_indexes = rule_indexes.map { |rule_index| matrix.index { |row| row[rule_index] == 1 } }
    field_indexes.map { |idx| idx ? @my_ticket[idx] : 1 }.product(1_i64)
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
