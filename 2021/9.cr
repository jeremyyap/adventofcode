require "../utils/grid"

class Program
  @inputs: Array(Array(Int32))

  def initialize
    @inputs = File.read("9.txt").chomp.split("\n").map { |line| line.chars.map { |c| c.to_i } }
  end

  def part_1
    @inputs.each_with_index.sum do |row, y|
      row.each_with_index.sum do |height, x|
        (
          (x == 0 || @inputs[y][x-1] > height) &&
          (y == 0 || @inputs[y-1][x] > height) &&
          (y == @inputs.size - 1 || @inputs[y+1][x] > height) &&
          (x == row.size - 1 || @inputs[y][x+1] > height)
        ) ? 1 + height : 0
      end
    end
  end

  def flood_fill(x : Int32, y : Int32)
    return 0 if x < 0 || y < 0 || x >= @inputs[0].size || y >= @inputs.size || @inputs[y][x] == 9

    @inputs[y][x] = 9
    return 1 + flood_fill(x-1, y) + flood_fill(x, y-1) + flood_fill(x+1, y) + flood_fill(x, y+1)
  end

  def part_2
    basins = [] of Int32
    each_with_coordinate(@inputs) do |height, y, x|
      basins << flood_fill(x, y) if height != 9
    end
    basins.sort.last(3).product
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
