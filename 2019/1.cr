class Program
  @inputs: Array(Int32)

  def initialize
    @inputs = File.read("1.txt").chomp.split.map(&.to_i)
  end

  def part_1
    @inputs.sum { |x| x // 3 - 2 }
  end

  def part_2
    @inputs.sum do |x|
      fuel = 0
      until x <= 0
        x = x // 3 - 2
        fuel += x
      end
      fuel
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
