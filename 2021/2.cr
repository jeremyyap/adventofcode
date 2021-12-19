class Program
  @inputs: Array(Tuple(String, Int32))

  def initialize
    @inputs = File.read("2.txt").chomp.split("\n").map do |line|
      command, x = line.split(" ")
      { command, x.to_i }
    end
  end

  def part_1
    horizontal = 0
    depth = 0
    @inputs.each do |command, x|
      if command == "forward"
        horizontal += x
      elsif command == "down"
        depth += x
      elsif command == "up"
        depth -= x
      end
    end
    horizontal * depth
  end

  def part_2
    horizontal = 0
    depth = 0
    aim = 0
    @inputs.each do |command, x|
      if command == "forward"
        horizontal += x
        depth += aim * x
      elsif command == "down"
        aim += x
      elsif command == "up"
        aim -= x
      end
    end
    horizontal * depth
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
