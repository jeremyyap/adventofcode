require "../utils/coordinate"

class Program
  @blizzards: Array(Set(Coordinate))
  @start: Coordinate
  @goal: Coordinate
  @width: Int32
  @height: Int32

  def initialize
    @blizzards = Array.new(4) { Set(Coordinate).new }
    inputs = File.read("24.txt").chomp.split("\n")
    inputs.each_with_index do |row, y|
      row.chars.each_with_index do |cell, x|
        case cell
        when '>'
          @blizzards[0].add({x, y})
        when 'v'
          @blizzards[1].add({x, y})
        when '<'
          @blizzards[2].add({x, y})
        when '^'
          @blizzards[3].add({x, y})
        end
      end
    end

    @start = { 1, 0 }
    @width = inputs[0].size - 2
    @height = inputs.size - 2
    @goal = { @width, @height + 1 }
  end

  def next_positions(coordinate : Coordinate)
    x, y = coordinate
    candidates = [{-1, 0}, {1, 0}, {0, 1}, {0, -1}, {0, 0}]
      .map { |dx, dy| { x + dx, y + dy} }
      .select { |x, y| 1 <= x && x <= @width && 1 <= y && y <= @height || {x, y} == @start || {x, y} == @goal }
      .to_set
    @blizzards.reduce(candidates) { |result, blizzard_set| result - blizzard_set }
  end

  def move_blizzards
    @blizzards[0] = @blizzards[0].map { |x, y| { x % @width + 1, y } }.to_set
    @blizzards[1] = @blizzards[1].map { |x, y| { x, y % @height + 1 } }.to_set
    @blizzards[2] = @blizzards[2].map { |x, y| { (x - 2) % @width + 1, y } }.to_set
    @blizzards[3] = @blizzards[3].map { |x, y| { x, (y - 2) % @height + 1 } }.to_set
  end

  def bfs(start : Coordinate, goal : Coordinate)
    coordinates = Set(Coordinate).new
    coordinates.add(start)
    minutes = 1

    loop do
      move_blizzards
      next_coordinates = Set(Coordinate).new
      
      coordinates.each do |coordinate|
        next_positions(coordinate).each do |candidate|
          if candidate == goal
            return minutes
          end
          next_coordinates.add(candidate)
        end
      end
      coordinates = next_coordinates
      minutes += 1
    end
  end

  def execute
    part_1 = bfs(@start, @goal)
    part_2 = part_1 + bfs(@goal, @start) + bfs(@start, @goal)
    puts part_1
    puts part_2
  end
end

Program.new.execute
