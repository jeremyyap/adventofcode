alias Triple = Tuple(Int32, Int32, Int32)

class Program
  @inputs: Array(Array(Triple))

  def initialize
    @inputs = File.read("19.txt").strip.split("\n\n").map do |chunk|
      chunk.split("\n")[1..-1].map do |row|
        Triple.from(row.split(",").map(&.to_i))
      end
    end
  end

  @@axes: Array(Triple) = {0, 1, 2}.permutations.map { |p| Triple.from(p) }
  @@signs: Array(Triple) = {-1, 1}.cartesian_product({-1, 1}, {-1, 1})

  def transform(b, axes, signs, offsets)
    { signs[0] * b[axes[0]] - offsets[0],
      signs[1] * b[axes[1]] - offsets[1],
      signs[2] * b[axes[2]] - offsets[2] }
  end

  def match(arr1 : Array(Triple), arr2 : Array(Triple))
    @@axes.cartesian_product(@@signs).each do |axes, signs|
      counts = Hash(Triple, Int32).new(0)
      arr1.cartesian_product(arr2).each do |b1, b2|
        transformed = transform(b2, axes, signs, b1)
        counts[transformed] += 1
        return axes, signs, transformed if counts[transformed] >= 12
      end
    end
    return nil, nil, nil
  end

  def dfs(vertex : Int32, visited : Int32, edges)
    return [] of Int32 if visited & (1 << vertex) != 0
    return [0] if vertex == 0

    edges.select { |e| e[0] == vertex }.each do |edge|
      path = dfs(edge[1], visited | (1 << vertex), edges)
      return [vertex] + path if path.size > 0
    end
    return [] of Int32
  end

  def transform_all_to_scanner_zero(beacons, scanner_id, transformations)
    path = dfs(scanner_id, 0, transformations.keys)
    path.each_cons(2).reduce(beacons) do |arr, (a, b)|
      arr.map { |beacon| transform(beacon, *transformations[{a,b}]) }
    end
  end

  def execute
    transformations = Hash(Tuple(Int32, Int32), Tuple(Triple, Triple, Triple)).new
    (0..(@inputs.size-1)).to_a.permutations(2).each do |(a, b)|
      axes, signs, offsets = match(@inputs[b], @inputs[a])
      transformations[{a,b}] = { axes, signs, offsets } if axes && signs && offsets
    end

    # Part 1
    beacons = @inputs[0].to_set
    @inputs.each_with_index do |arr, scanner_id|
      next if scanner_id == 0
      beacons.concat(transform_all_to_scanner_zero(arr, scanner_id, transformations))
    end
    puts beacons.size

    # Part 2
    puts (0..(@inputs.size-1)).map do |scanner_id|
      transform_all_to_scanner_zero([{ 0, 0, 0 }], scanner_id, transformations)[0]
    end.permutations(2).max_of { |(b1, b2)| b1.zip(b2).sum { |x1, x2| (x2 - x1).abs } }
  end
end

Program.new.execute
