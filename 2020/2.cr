class Program
  @inputs: Array(String)

  def initialize
    @inputs = File.read("2.txt").chomp.split("\n")
  end

  def part_1
    @inputs.count do |line|
      range, letter, password = line.split(' ')
      min, max = range.split('-').map(&.to_i)
      char = letter[0]

      occurrences = password.chars.count(char)
      min <= occurrences && occurrences <= max
    end
  end

  def part_2
    @inputs.count do |line|
      range, letter, password = line.split(' ')
      left, right = range.split('-').map(&.to_i)
      char = letter[0]

      (password[left - 1] == char) ^ (password[right - 1] == char)
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
