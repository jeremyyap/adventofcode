require "../utils/coordinate"

class Program
  @grid: Hash(Coordinate, Char)

  def initialize
    @grid = Hash(Coordinate, Char).new { '.' }
  end

  def initialize_grid
    input = File.read("14.txt").chomp.split("\n")
    @grid = Hash(Coordinate, Char).new { '.' }
    input.each do |row|
      points = row.split(" -> ")
      points.each_cons(2) do |(a, b)|
        x1, y1 = a.split(',').map(&.to_i)
        x2, y2 = b.split(',').map(&.to_i)

        if x1 == x2
          y1, y2 = y2, y1 if y1 > y2
          (y1..y2).each { |y| @grid[{y, x1}] = '#' }
        else
          x1, x2 = x2, x1 if x1 > x2
          (x1..x2).each { |x| @grid[{y1, x}] = '#' }
        end
      end
    end
  end

  def part_1
    initialize_grid
    max_y = @grid.keys.map { |key| key[0] }.max

    filled = false
    count = 0
    while !filled
      sand = { 0, 500 }
      fall = true
      while fall && sand[0] < max_y
        [
          { sand[0] + 1, sand[1] },
          { sand[0] + 1, sand[1] - 1 },
          { sand[0] + 1, sand[1] + 1 }
        ].each do |next_position|
          fall = false
          if @grid[next_position] == '.'
            sand = next_position
            fall = true
            break
          end
        end
      end
      @grid[sand] = 'o' if sand[0] < max_y
      filled = true if sand[0] >= max_y
      count += 1 if sand[0] < max_y
    end
    count
  end

  def part_2
    initialize_grid
    max_y = @grid.keys.map { |key| key[0] }.max + 1

    filled = false
    count = 0
    while !filled
      sand = { 0, 500 }
      fall = true
      while fall && sand[0] < max_y
        [
          { sand[0] + 1, sand[1] },
          { sand[0] + 1, sand[1] - 1 },
          { sand[0] + 1, sand[1] + 1 }
        ].each do |next_position|
          fall = false
          if @grid[next_position] == '.'
            sand = next_position
            fall = true
            break
          end
        end
      end
      @grid[sand] = 'o'
      count += 1
      filled = true if sand == { 0, 500 }
    end
    count
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
