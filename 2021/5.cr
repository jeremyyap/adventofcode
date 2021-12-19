class Point
  getter x : Int32
  getter y : Int32
  def initialize(x : Int32, y : Int32)
    @x = x
    @y = y
  end
end

alias Segment = Tuple(Point, Point)

class Program
  @inputs: Array(Segment)
  @map: Hash(Tuple(Int32, Int32), Int32)

  def initialize
    @inputs = File.read("5.txt").chomp.split("\n").map do |line|
      p1, p2 = line.split(" -> ")
      p1x, p1y = p1.split(",").map(&.to_i)
      p2x, p2y = p2.split(",").map(&.to_i)
      { Point.new(p1x, p1y), Point.new(p2x, p2y) }
    end
    @map = Hash(Tuple(Int32, Int32), Int32).new(0)
  end

  def iterator(first : Int32, last : Int32)
    return Iterator.of(first) if first == last
    first < last ? (first..last).each : first.downto(last)
  end

  def plot_points(s : Segment)
    x_range = iterator(s[0].x, s[1].x)
    y_range = iterator(s[0].y, s[1].y)
    x_range.zip(y_range).each { |x, y| @map[{x,y}] += 1 }
  end

  def execute
    perpendiculars, diagonals =
      @inputs.partition { |s| s[0].x == s[1].x || s[0].y == s[1].y }

    # part 1
    perpendiculars.each { |s| plot_points(s) }
    puts @map.count { |k, v| v > 1 }

    # part 2
    diagonals.each { |s| plot_points(s) }
    puts @map.count { |k, v| v > 1 }
  end
end

Program.new.execute
