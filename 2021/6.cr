class Program
  @inputs: Array(Int32)

  def initialize
    @inputs = File.read("6.txt").strip.split(",").map(&.to_i)
  end

  def simulate(days : Int32)
    buckets = [0_i64] * 9
    @inputs.each do |age|
      buckets[age] += 1
    end

    days.times do
      buckets.rotate!
      buckets[6] += buckets[-1]
    end
    buckets.sum
  end

  def execute
    puts simulate(80) # part 1
    puts simulate(256) # part 2
  end
end

Program.new.execute
