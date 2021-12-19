alias Coordinate3 = Tuple(Int32, Int32, Int32)
alias Coordinate4 = Tuple(Int32, Int32, Int32, Int32)

class Program
  @input : Array(Array(Char))

  def initialize
    @input = File.read("17.txt").chomp.split('\n').map(&.chars)
  end

  def neighbours(cube : Coordinate3)
    x, y, z = cube
    [x-1, x, x+1].flat_map do |xx|
      [y-1, y, y+1].flat_map do |yy|
        [z-1, z, z+1].map do |zz|
          { xx, yy, zz }
        end
      end
    end.select { |neighbour| neighbour != cube }
  end

  def neighbours(cube : Coordinate4)
    x, y, z, w = cube
    [x-1, x, x+1].flat_map do |xx|
      [y-1, y, y+1].flat_map do |yy|
        [z-1, z, z+1].flat_map do |zz|
          [w-1, w, w+1].map do |ww|
            { xx, yy, zz, ww }
          end
        end
      end
    end.select { |neighbour| neighbour != cube }
  end

  def boot(cubes : Array(Coordinate3) | Array(Coordinate4))
    6.times do
      neighbour_counts = Hash(Coordinate3 | Coordinate4, Int32).new(0)
      cubes.each do |cube|
        neighbours(cube).each { |neighbour| neighbour_counts[neighbour] += 1 }
      end
      cubes = neighbour_counts.keys.select do |cube|
        neighbour_counts[cube] == 3 ||
        neighbour_counts[cube] == 2 && cubes.includes?(cube)
      end
    end
    cubes.size
  end

  def part_1
    cubes = [] of Coordinate3
    @input.each_with_index do |row, y|
      row.each_with_index do |cube, x|
        cubes << { x, y, 0 } if cube == '#'
      end
    end

    boot(cubes)
  end

  def part_2
    cubes = [] of Coordinate4
    @input.each_with_index do |row, y|
      row.each_with_index do |cube, x|
        cubes << { x, y, 0, 0 } if cube == '#'
      end
    end
    boot(cubes)
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
