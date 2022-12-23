require "../utils/coordinate"

class Program
  @elves: Set(Coordinate)
  @inputs: Set(Coordinate)
  @checks: Array(Proc(Int32, Int32, (Tuple(Int32, Int32) | Nil)))

  def initialize
    @inputs = Set(Coordinate).new
    @elves = Set(Coordinate).new
    @checks = [->check_north(Int32, Int32), ->check_south(Int32, Int32), ->check_west(Int32, Int32), ->check_east(Int32, Int32)]
    File.read("23.txt").chomp.split("\n").each_with_index do |row, y|
      row.chars.each_with_index do |cell, x|
        @inputs.add({x, y}) if cell == '#'
      end
    end
  end

  def empty_ground
    width = @elves.max_of { |x, y| x } - @elves.min_of { |x, y| x } + 1
    height = @elves.max_of { |x, y| y } - @elves.min_of { |x, y| y } + 1
    width * height - @elves.size
  end

  def check_adjacent(x : Int32, y : Int32)
    ((x-1)..(x+1)).each do |xx|
      ((y-1)..(y+1)).each do |yy|
        next if x == xx && y == yy
        return true if @elves.includes?({xx, yy})
      end
    end
    false
  end

  def check_north(x : Int32, y : Int32)
    { x, y-1 } if (Set(Coordinate).new([{ x-1, y-1 }, { x, y-1 }, { x+1, y-1 }]) & @elves).empty?
  end

  def check_south(x : Int32, y : Int32)
    { x, y+1 } if (Set(Coordinate).new([{ x-1, y+1 }, { x, y+1 }, { x+1, y+1 }]) & @elves).empty?
  end

  def check_west(x : Int32, y : Int32)
    { x-1, y } if (Set(Coordinate).new([{ x-1, y-1 }, { x-1, y }, { x-1, y+1 }]) & @elves).empty?
  end

  def check_east(x : Int32, y : Int32)
    { x+1, y } if (Set(Coordinate).new([{ x+1, y-1 }, { x+1, y }, { x+1, y+1 }]) & @elves).empty?
  end

  def step
    proposals = Hash(Coordinate, Coordinate).new
    @elves.each do |x, y|
      next unless check_adjacent(x, y)
      proposal = @checks.map { |check| check.call(x, y) }.compact.first?
      proposals[{x,y}] = proposal if proposal
    end

    raise "Done" if proposals.empty?

    counts = Hash(Coordinate, Int32).new { 0 }
    proposals.values.each { |proposal| counts[proposal] += 1 }
    proposals.each do |from, to|
      next if counts[to] > 1
      @elves.delete(from)
      @elves.add(to)
    end

    @checks.rotate!(1)
  end

  def part_1
    @elves = @inputs.dup
    @checks = [->check_north(Int32, Int32), ->check_south(Int32, Int32), ->check_west(Int32, Int32), ->check_east(Int32, Int32)]
    10.times { step }
    empty_ground
  end

  def part_2
    @elves = @inputs.dup
    @checks = [->check_north(Int32, Int32), ->check_south(Int32, Int32), ->check_west(Int32, Int32), ->check_east(Int32, Int32)]
    i = 0
    loop do
      begin
        i += 1
        step
      rescue
        break
      end
    end
    i
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
