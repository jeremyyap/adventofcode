require "../utils/coordinate"
require "../utils/heap"

class Program
  @inputs: Array(Array(Int32))
  @height: Int32
  @width: Int32

  def initialize
    @inputs = File.read("15.txt").strip.split("\n").map { |line| line.chars.map(&.to_i) }
    @height = @inputs.size
    @width = @inputs[0].size
  end

  def adjacent_cells(cell : Coordinate)
    moveY = [0, 0, -1, 1]
    moveX = [1, -1, 0, 0]

    (0..3)
      .map { |i| { cell[0] + moveY[i], cell[1] + moveX[i] } }
      .select { |cell| cell[0] >= 0 && cell[0] < @height && cell[1] >= 0 && cell[1] < @width }
  end

  def danger_level(cell : Coordinate)
    y = cell[0] % @inputs.size
    x = cell[1] % @inputs[0].size
    (@inputs[y][x] + cell[0] // @inputs.size + cell[1] // @inputs[0].size - 1) % 9 + 1
  end

  def dijkstra
    visited = Set(Tuple(Int32, Int32)).new
    heap = Heap(Tuple(Int32, Int32, Int32)).new { |a, b| a[2] < b[2] }

    heap << {0, 0, 0}
    loop do
      current = heap.pop
      next if visited.includes?(current[0..1])
      return current[2] if current[0..1] == { @height - 1, @width - 1 }
      visited << current[0..1]
      adjacent_cells(current[0..1]).each do |adj|
        next if visited.includes?(adj)
        heap << { adj[0], adj[1], current[2] + danger_level(adj)}
      end
    end
  end

  def execute
    # part 1
    puts dijkstra

    @height *= 5
    @width *= 5

    # part 2
    puts dijkstra
  end
end

Program.new.execute
