class Program
  @inputs: Array(Int32)

  def initialize
    @inputs = File.read("1.txt").split.map(&.to_i)
  end

  def part_1
    @inputs.each_cons(2).count { |cons| cons[0] < cons[1] }
  end

  def part_2
    @inputs.each_cons(4).count { |cons| cons[0] < cons[3] }
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
