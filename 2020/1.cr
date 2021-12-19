class Program
  @inputs: Array(Int32)

  def initialize
    @inputs = File.read("1.txt").chomp.split.map(&.to_i)
  end

  def part_1
    set = Set(Int32).new
    @inputs.each do |x|
      y = 2020 - x
      if set.includes?(y)
        return y * x
      end

      set.add(x)
    end
  end

  def part_2
    set = Set(Int32).new
    @inputs.each_with_index do |x, i|
      @inputs.each_with_index do |y, j|
        if (j > i)
          z = 2020 - x - y
          return x * y * z if set.includes?(z)
        end
      end

      set.add(x)
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
