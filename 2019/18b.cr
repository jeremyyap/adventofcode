require "../utils/coordinate"

MAX_INT = 1 << 30

class Program
  KEYS = ('a'..'z').to_a
  DOORS = ('A'..'Z').to_a

  @maze: Array(Array(Char))

  def initialize
    @maze = File.read("18b.txt").split.map(&.chars)
    @shortest_paths = Hash(Char, Hash(Char, { Int32, Array(Char) })).new do |hash,key|
      hash[key] = Hash(Char, { Int32, Array(Char) }).new { { MAX_INT, [] of Char } }
    end
    @memo = Hash({ Char, Char, Char, Char, Int32 }, Int32).new { MAX_INT }
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

  def all_keys_shortest_path(robots : Array(Char), visited : Int32)
    current_memo = {robots[0], robots[1], robots[2], robots[3], visited}
    final_memo = {'0', '1', '2', '3', visited}

    if visited == (1 << 26) - 1
      @memo[final_memo] = [
        @memo[current_memo],
        @memo[final_memo]
      ].min
      return
    end

    robots.each_with_index do |last_key, index|
      KEYS.select do |key|
        unvisited = (1 << (key - 'a')) & visited == 0
        reachable = @shortest_paths[last_key].has_key?(key) &&
          @shortest_paths[last_key][key][1].all? { |required_key| (1 << (required_key - 'a')) & visited != 0 }
        unvisited && reachable
      end.each do |new_key|
        new_visited = (1 << (new_key - 'a')) | visited
        new_distance = @memo[current_memo] + @shortest_paths[last_key][new_key][0]
        robots[index] = new_key
        new_memo = {robots[0], robots[1], robots[2], robots[3], new_visited}
        if (new_distance < @memo[new_memo])
          @memo[new_memo] = new_distance
          all_keys_shortest_path(robots, new_visited)
        end
        robots[index] = last_key
      end
    end
  end

  def execute
    points = ['0', '1', '2', '3'] + KEYS
    points.each do |start|
      bfs(start)
    end

    @memo[{'0', '1', '2', '3', 0}] = 0
    all_keys_shortest_path(['0', '1', '2', '3'], 0)
    puts @memo[{'0', '1', '2', '3', (1 << 26) - 1}]
  end
end

Program.new.execute
