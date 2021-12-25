require "../utils/grid"

class Program
  @inputs: Array(Array(Char))

  def initialize
    @inputs = File.read("25.txt").chomp.split("\n").map(&.chars)
  end

  def execute
    grid = @inputs
    width = grid[0].size
    height = grid.size
    count = 0
    next_grid = grid.clone

    loop do
      moved = false
      each_coordinate(grid) do |i,j|
        next unless grid[i][j] == '>' && grid[i][(j+1) % width] == '.'
        next_grid[i][j] = '.'
        next_grid[i][(j+1) % width] = '>'
        moved = true
      end

      grid = next_grid.clone

      each_coordinate(grid) do |i,j|
        next unless grid[i][j] == 'v' && grid[(i + 1) % height][j] == '.'
        next_grid[i][j] = '.'
        next_grid[(i + 1) % height][j] = 'v'
        moved = true
      end
      count += 1
      grid = next_grid.clone
      break unless moved
    end

    puts count
  end
end

Program.new.execute
