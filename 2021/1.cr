class Program
  @inputs: Array(Int32)

  def initialize
    @inputs = File.read("1.txt").chomp.split.map(&.to_i)
  end

  def part_1
    @inputs.each_cons(2).count { |(a, b)| a < b }
  end

  def part_2
    @inputs.each_cons(4).count { |(a, _, _, b)| a < b }
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
