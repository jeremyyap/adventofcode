require "../utils/coordinate"

class Program
  @maze: Array(Array(Char))

  def initialize
    @maze = File.read("12.txt").split.map(&.chars)
  end

  def find_point(point)
    @maze.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        return {i, j} if cell == point
      end
    end
    return { -1, -1 }
  end

  def adjacent_cells(cell : Coordinate)
    moveX = [0, 0, -1, 1]
    moveY = [1, -1, 0, 0]

    (0..3).map { |i| { cell[0] + moveX[i], cell[1] + moveY[i] } }
  end

  def bfs(start : Coordinate)
    queue = [] of {Coordinate, Int32, Char}
    visited = Set(Coordinate).new
    queue.push({start, 0, 'a'})

    while !queue.empty?
      cell, depth, current_elevation = queue.shift
      next if cell[0] < 0 || cell[1] < 0 || cell[0] >= @maze.size || cell[1] >= @maze[0].size
     cell_value = @maze[cell[0]][cell[1]]
      next_elevation = cell_value
      next_elevation = 'z' if cell_value == 'E'
      next_elevation = 'a' if cell_value == 'S'
      next if next_elevation.ord - current_elevation.ord > 1 || visited.includes?(cell)
      return depth if cell_value == 'E'
      visited.add(cell)

      adjacent_cells(cell).each { |next_cell| queue.push({next_cell, depth + 1, cell_value == 'S' ? 'a' : next_elevation}) }
    end
    @maze.size * @maze[0].size # no path found
  end

  def part_1
    bfs(find_point('S'))
  end

  def part_2
    @maze.each_index.min_of { |i| bfs({ i, 0 }) }
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
