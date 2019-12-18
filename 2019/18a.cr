require "../utils/coordinate"

class Program
  KEYS = ('a'..'z').to_a
  DOORS = ('A'..'Z').to_a

  @maze: Array(Array(Char))

  def initialize
    @maze = File.read("18a.txt").split.map(&.chars)
    @shortest_paths = Hash(Char, Hash(Char, { Int32, Array(Char) })).new do |hash,key|
      hash[key] = Hash(Char, { Int32, Array(Char) }).new
    end
    @memo = Hash({ Char, Int32 }, Int32).new { 1 << 30 }
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

  def bfs(start : Char)
    queue = [] of {Coordinate, Int32, Array(Char)}
    visited = Set(Coordinate).new
    queue.push({find_point(start), 0, [] of Char})

    while !queue.empty?
      cell, depth, required_keys = queue.shift
      cell_value = @maze[cell[0]][cell[1]]
      next if cell_value == '#' || visited.includes?(cell)
      visited.add(cell)

      @shortest_paths[start][cell_value] = { depth, required_keys } if KEYS.includes? cell_value
      required_keys = required_keys + [cell_value.downcase] if KEYS.includes? cell_value.downcase
      adjacent_cells(cell).each { |next_cell| queue.push({next_cell, depth + 1, required_keys}) }
    end
  end

  def all_keys_shortest_path(start : Char, visited : Int32)
    if visited == (1 << 26) - 1
      @memo[{'@', visited}] = [@memo[{'@', visited}], @memo[{start, visited}]].min
      return
    end

    KEYS.select do |key|
      unvisited = (1 << (key - 'a')) & visited == 0
      required_keys = @shortest_paths[start][key][1]
      reachable = required_keys.all? { |required_key| (1 << (required_key - 'a')) & visited != 0 }
      unvisited && reachable
    end.each do |key|
      new_visited = (1 << (key - 'a')) | visited
      new_distance = @memo[{start, visited}] + @shortest_paths[start][key][0]
      memo_key = {key, new_visited}
      if (new_distance < @memo[memo_key])
        @memo[memo_key] = new_distance
        all_keys_shortest_path(key, new_visited)
      end
    end
  end

  def execute
    points = ['@'] + KEYS
    points.each do |start|
      bfs(start)
    end

    @memo[{'@', 0}] = 0
    all_keys_shortest_path('@', 0)
    puts @memo[{'@', (1 << 26) - 1}]
  end
end

Program.new.execute
