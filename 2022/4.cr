class Program
  @inputs: Array(Tuple(Tuple(Int32,Int32), Tuple(Int32,Int32)))

  def initialize
    rows = File.read("4.txt").chomp.split("\n")
    @inputs = rows.map do |row|
      x1, x2, y1, y2 = 1, 2, 3, 4
      { {x1.to_i,x2.to_i}, {y1.to_i,y2.to_i} }
    end
  end

  def contains?(x, y)
    (x[0] <= y[0] && y[1] <= x[1]) ||
    (y[0] <= x[0] && x[1] <= y[1]) 
  end

  def overlaps?(x, y)
    [x[0], y[0]].max <= [x[1], y[1]].min
  end

  def part_1
    @inputs.count { |input| contains?(input[0], input[1]) }
  end

  def part_2
    @inputs.count { |input| overlaps?(input[0], input[1]) }
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
