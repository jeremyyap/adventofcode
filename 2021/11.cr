require "../utils/grid"

class Program
  @inputs: Array(Array(Int32))

  def initialize
    @inputs = File.read("11.txt").chomp.split("\n").map { |line| line.chars.map(&.to_i) }
  end

  def adjacent(i : Int32, j : Int32)
    first_i = i == 0 ? i : i - 1
    first_j = j == 0 ? j : j - 1
    last_i = i == 9 ? i : i + 1
    last_j = j == 9 ? j : j + 1

    (first_i..last_i).to_a.cartesian_product((first_j..last_j).to_a) - [{i,j}]
  end

  def step(grid)
    count = 0
    flashers = [] of Tuple(Int32, Int32)

    each_coordinate(grid) do |i, j|
      grid[i][j] += 1
      flashers << {i, j} if grid[i][j] > 9
    end

    while !flashers.empty?
      count += 1
      flasher = flashers.pop
      grid[flasher[0]][flasher[1]] = -1
      adjacent(flasher[0], flasher[1]).each do |adj|
        grid[adj[0]][adj[1]] += 1 unless grid[adj[0]][adj[1]] == -1
        flashers << adj if grid[adj[0]][adj[1]] == 10
      end
    end

    each_coordinate(grid) do |i, j|
      grid[i][j] = 0 if grid[i][j] == -1
    end
    count
  end

  def part_1
    grid = @inputs.clone.map(&.clone)

    100.times.sum do
      step(grid)
    end
  end

  def part_2
    grid = @inputs.clone.map(&.clone)

    step_count = 0
    loop do
      step_count += 1
      return step_count if step(grid) == 100
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
