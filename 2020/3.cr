require "big"

class Program
  @inputs: Array(Array(Char))
  @width: Int32
  @height: Int32

  def initialize
    @inputs = File.read("3.txt").split.map { |line| line.chars }
    @width = @inputs[0].size
    @height = @inputs.size
  end

  def count_slope(xx, yy)
    x = 0
    y = 0
    count = 0
    while y < @height - 1
      x = (x + xx) % @width
      y += yy
      count += 1 if @inputs[y][x] == '#'
    end
    count
  end

  def execute
    # Part 1
    puts count_slope(3, 1)

    # Part 2
    slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    puts slopes.map { |s| count_slope(s[0], s[1]) }.product(BigInt.new(1))
  end
end

Program.new.execute
