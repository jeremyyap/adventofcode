class Program
  @inputs: Array(Int32)

  def initialize
    @inputs = File.read("7.txt").split(",").map(&.to_i)
  end

  def part_1
    min, max = @inputs.minmax
    (min..max).min_of do |target|
      @inputs.sum { |i| (target - i).abs }
    end
  end

  def part_2
    min, max = @inputs.minmax
    (min..max).min_of do |target|
      @inputs.sum { |i| distance = (target - i).abs; distance * (distance + 1) // 2 }
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
