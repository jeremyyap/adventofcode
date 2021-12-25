alias Cube = Tuple(Int32, Int32, Int32, Int32, Int32, Int32)

class Program
  @inputs : Array(Tuple(String, Cube))

  def initialize
    @inputs = File.read("22.txt").chomp.split("\n").map do |line|
      on_off, rest = line.split(" ")
      axes = rest.split(",")
      axis_ranges = axes.flat_map do |axis|
        _, rest = axis.split("=")
        min, max = rest.split("..")
        [min.to_i, max.to_i]
      end
      { on_off, Cube.from(axis_ranges) }
    end
  end

  def intersect_ranges(r1min, r1max, r2min, r2max)
    min = [r1min, r2min].max
    max = [r1max, r2max].min
    return min, max if min < max
  end

  def intersection(cube1, cube2)
    x_range = intersect_ranges(cube1[0], cube1[1], cube2[0], cube2[1])
    y_range = intersect_ranges(cube1[2], cube1[3], cube2[2], cube2[3])
    z_range = intersect_ranges(cube1[4], cube1[5], cube2[4], cube2[5])
    return { *x_range, *y_range, *z_range } if x_range && y_range && z_range
  end

  def count_cubes(initialization : Bool)
    cubes = Hash(Cube, Int64).new(0)
    @inputs.each do |(on_off, cube)|
      cube2 = initialization ? intersection(cube, {-50,50,-50,50,-50,50}) : cube
      next if cube2 == nil
      cube2 = cube2.as(Cube)
      updates = Array(Tuple(Cube, Int64)).new
      cubes.each do |cube1, count|
        intersecting_cube = intersection(cube1, cube2)
        if intersecting_cube != nil
          updates << { intersecting_cube.not_nil!, -count }
        end
      end
      cubes[cube2] += on_off == "on" ? 1 : 0
      updates.each { |cube, count| cubes[cube] += count; cubes.delete(cube) if cubes[cube] == 0 }
    end

    cubes.sum do |cube, count|
      count.to_i64 * (cube[1] - cube[0] + 1) * (cube[3] - cube[2] + 1) * (cube[5] - cube[4] + 1)
    end
  end

  def execute
    puts count_cubes(true)  # part 1
    puts count_cubes(false) # part 2
  end
end

Program.new.execute
