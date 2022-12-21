class Program
  @inputs: Array(Tuple(Int32, Int32, Int32))

  def initialize
    @inputs = File.read("18.txt").chomp.split("\n").map do |row|
      x, y, z = row.split(',').map(&.to_i)
      { x, y, z }
    end
  end

  def cube_faces(cube : Tuple(Int32, Int32, Int32))
    x, y, z = cube
    [
      { x, y, z, 'X' },
      { x, y, z, 'Y' },
      { x, y, z, 'Z' },
      { x + 1, y, z, 'X' },
      { x, y + 1, z, 'Y' },
      { x, y, z + 1, 'Z' }
    ]
  end

  def adjacent_cubes(cube : Tuple(Int32, Int32, Int32))
    x, y, z = cube
    [
      { x + 1, y, z },
      { x - 1, y, z },
      { x, y + 1, z },
      { x, y - 1, z },
      { x, y, z + 1 },
      { x, y, z - 1 }
    ]
  end

  def part_1
    surfaces = Set(Tuple(Int32, Int32, Int32, Char)).new
    @inputs.each do |cube|
      cube_faces(cube).each do |face|
        if surfaces.includes?(face)
          surfaces.delete(face)
        else
          surfaces.add(face)
        end
      end
    end
    surfaces.size
  end

  def part_2
    x_min, x_max = @inputs.map { |x,y,z| x }.minmax
    y_min, y_max = @inputs.map { |x,y,z| y }.minmax
    z_min, z_max = @inputs.map { |x,y,z| z }.minmax

    visited = Set(Tuple(Int32, Int32, Int32)).new
    outside_faces = Set(Tuple(Int32, Int32, Int32, Char)).new
    cubes_set = @inputs.to_set
    queue = [{ x_min - 1, y_min - 1, z_min - 1 }]
    while !queue.empty?
      cube = queue.pop
      next if visited.includes?(cube) || cubes_set.includes?(cube)
      visited.add(cube)
      outside_faces.concat(cube_faces(cube))
      next_cubes = adjacent_cubes(cube).select do |x, y, z|
        x_min - 1 <= x && x <= x_max + 1 &&
        y_min - 1 <= y && y <= y_max + 1 &&
        z_min - 1 <= z && z <= z_max + 1
      end
      queue.concat(next_cubes)
    end

    surfaces = Set(Tuple(Int32, Int32, Int32, Char)).new
    @inputs.each { |cube| surfaces.concat(cube_faces(cube)) }
    (surfaces & outside_faces).size
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
