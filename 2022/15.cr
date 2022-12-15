require "../utils/coordinate"

class Program
  @inputs: Array(Tuple(Int32, Int32, Int32, Int32))

  def initialize
    rows = File.read("15.txt").chomp.split("\n")
    @inputs = rows.map do |row|
      x1, y1, x2, y2 = row.match(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/)
      .try(&.captures).not_nil!
      .map { |param| param.not_nil!.to_i }
      { x1, y1, x2, y2 }
    end
  end

  def part_1
    set = Set(Int32).new
    @inputs.each do |x1, y1, x2, y2|
      distance = (x1 - x2).abs + (y1 - y2).abs
      dy = (y1 - 2000000).abs
      dx = distance - dy
      if dx >= 0
        (0..dx).each do |dd|
          set.add(x1 + dd)
          set.add(x1 - dd)
        end
      end
    end
    set.size - 1 # there is 1 beacon at y = 2000000
  end

  def part_2
    transformed = @inputs.map do |x1, y1, x2, y2|
      distance = (x1 - x2).abs + (y1 - y2).abs
      {x1, y1, distance}
    end

    transformed.each do |x, y, distance|
      (0..4000000).each do |xx|
        yy = y + remaining
        # since the answer is unique, distress beacon is at distance + 1 for at least one sensor
        remaining = distance + 1 - (xx - x).abs 
        if 0 <= yy && yy <= 4000000 && transformed.all? { |x, y, distance| (x - xx).abs + (y - yy).abs > distance }
          return xx.to_i64 * 4000000_i64 + yy
        end

        yy = y - remaining
        if 0 <= yy && yy <= 4000000 && transformed.all? { |x, y, distance| (x - xx).abs + (y - yy).abs > distance }
          return xx.to_i64 * 4000000_i64 + yy
        end
      end
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
