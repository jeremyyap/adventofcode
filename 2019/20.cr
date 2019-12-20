require "../utils/coordinate"

class Program
  KEYS = ('a'..'z').to_a
  DOORS = ('A'..'Z').to_a

  @maze: Array(Array(Char))
  @portals: Hash(Coordinate, Coordinate)

  def initialize
    @maze = File.read("20.txt")[0..-2].split('\n').map(&.chars)
    @portals = Hash(Coordinate, Coordinate).new
  end

  def cell_value(cell : Coordinate)
    @maze[cell[0]][cell[1]]
  end

  def adjacent_cells(cell : Coordinate)
    moveX = [0, 1, -1, 0]
    moveY = [1, 0, 0, -1]

    (0..3).map { |i| { cell[0] + moveX[i], cell[1] + moveY[i] } }
  end

  def bfs(start : Coordinate, goal : Coordinate)
    queue = [] of {Coordinate, Int32, Int32}
    visited = Set({Coordinate, Int32}).new
    queue.push({start, 0, 0})

    while !queue.empty?
      cell, level, depth = queue.shift
      return depth if cell == goal && level == 0
      value = cell_value(cell)
      next if value != '.' || visited.includes?({cell, level}) || level < 0 || level > @portals.size // 2
      visited.add({cell, level})

      delta = yield cell
      adjacent_cells(cell).each { |next_cell| queue.push({next_cell, level, depth + 1}) }
      queue.push({@portals[cell], level + delta, depth + 1}) if @portals.has_key?(cell)
    end
  end

  def execute
    labels = Hash(String, Array(Coordinate)).new { [] of Coordinate }
    (1..@maze.size - 2).each do |i|
      (1..@maze.size - 2).each do |j|
        value = @maze[i][j]

        next unless value.uppercase?
        neighbours = adjacent_cells({i, j})
        next unless dot_cell = neighbours.find { |loc| cell_value(loc) == '.' }
        other_letter_index = neighbours.index { |loc| cell_value(loc).uppercase? }.as(Int32)
        other_letter = cell_value(neighbours[other_letter_index])
        portal_name = other_letter_index < 2 ? [value, other_letter].join("") : [other_letter, value].join("")
        labels[portal_name] = labels[portal_name] << dot_cell
      end
    end

    start = labels["AA"][0]
    goal = labels["ZZ"][0]
    labels.values.each do |cells|
      if cells.size == 2
        @portals[cells[0]] = cells[1]
        @portals[cells[1]] = cells[0]
      end
    end

    # Part 1
    part1 =  bfs(start, goal) { 0 }
    # Part 2
    part2 = bfs(start, goal) do |cell|
      cell[0] > 2 && cell[0] < @maze[0].size - 3 &&
      cell[1] > 2 && cell[1] < @maze.size - 3 ? 1 : -1
    end

    puts part1, part2
  end
end

Program.new.execute
