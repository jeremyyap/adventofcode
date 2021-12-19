class Program
  @inputs: Array(Int32)

  def initialize
    @inputs = File.read("10.txt").chomp.split.map(&.to_i)
  end

  def part_1
    adapters = @inputs.sort
    differences = adapters.each_cons(2).to_a.map { |(x, y)| y - x }
    (differences.count(1) + 1) * (differences.count(3) + 1)
  end

  def part_2
    adapters = @inputs.sort
    counts = adapters.map { |x| 0_i64 }
    counts[counts.size - 1] = 1
    (adapters.size - 2).downto(0) do |i|
      counts[i] = [i+1, i+2, i+3]
        .select { |j| j < adapters.size && adapters[j] - adapters[i] <= 3 }
        .sum { |j| counts[j] }
    end
    counts[0] + counts[1] + counts[2]
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
