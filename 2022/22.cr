class Program
  @map: Array(Array(Char))
  @path: Array(String)

  def initialize
    map, path = File.read("22.txt").chomp.split("\n\n")
    @map = map.split("\n").map { |row| row.chars }
    @path = path.scan(/(\d+|L|R)/).map { |match| match[0] }
  end

  def move(x : Int32, y : Int32, facing : Int32)
    case facing
    when 0
      x = (x + 1) % @map[0].size
      until@map[y]? && @map[y][x]? && @map[y][x] != ' '
        x = (x + 1) % @map[0].size
      end
    when 1
      y = (y + 1) % @map.size
      until@map[y]? && @map[y][x]? && @map[y][x] != ' '
        y = (y + 1) % @map.size
      end
    when 2
      x = (x - 1) % @map[0].size
      until@map[y]? && @map[y][x]? && @map[y][x] != ' '
        x = (x - 1) % @map[0].size
      end
    when 3
      y = (y - 1) % @map.size
      until@map[y]? && @map[y][x]? && @map[y][x] != ' '
        y = (y - 1) % @map.size
      end
    end
    { x, y, facing }
  end

  def move_cube(x : Int32, y : Int32, facing : Int32)
    case facing
    when 0
      x = (x + 1)
      if y < 50 && x == 150
        return { 99, 149 - y, 2 }
      elsif 50 <= y && y < 100 && x == 100
        return { y + 50, 49, 3 }
      elsif 100 <= y && y < 150 && x == 100
        return { 149, 149 - y, 2 }
      elsif 150 <= y && x == 50
        return { y - 100, 149, 3 }
      end
    when 1
      y = (y + 1)
      if x < 50 && y == 200
        return { x + 100, 0, 1 }
      elsif 50 <= x && x < 100 && y == 150
        return { 49, x + 100, 2 }
      elsif 100 <= x && y == 50
        return { 99, x - 50, 2 }
      end
    when 2
      x = (x - 1)
      if y < 50 && x == 49
        return { 0, 149 - y, 0 }
      elsif 50 <= y && y < 100 && x == 49
        return { y - 50, 100, 1 }
      elsif 100 <= y && y < 150 && x == -1
        return { 50, 149 - y, 0 }
      elsif 150 <= y && x == -1
        return { y - 100, 0, 1 }
      end
    when 3
      y = (y - 1)
      if x < 50 && y == 99
        return { 50, x + 50, 0 }
      elsif 50 <= x && x < 100 && y == -1
        return { 0, 100 + x, 0 }
      elsif 100 <= x && y == -1
        return { x - 100, 199, 3 }
      end
    end
    { x, y, facing }
  end

  def simulate(proc)
    y = 0
    x = @map[0].index { |c| c == '.'}.not_nil!
    facing = 0
    @path.each_slice(2) do |slice|
      steps = slice[0].to_i
      steps.times do
        next_position = proc.call(x, y, facing)
        break if @map[next_position[1]][next_position[0]] == '#'
        x, y, facing = next_position
      end

      turn = slice[1]?
      if turn == "L"
        facing = (facing - 1) % 4
      elsif turn == "R"
        facing = (facing + 1) % 4
      end
    end
    1000 * (y + 1) + 4 * (x + 1) + facing
  end

  def execute
    puts simulate(->move(Int32, Int32, Int32))      # part 1
    puts simulate(->move_cube(Int32, Int32, Int32)) # part 2
  end
end

Program.new.execute
