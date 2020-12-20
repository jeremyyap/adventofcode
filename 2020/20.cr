alias Image = Array(Array(Char))

class Program
  @tiles : Hash(Int32, Image)

  def initialize
    tiles = File.read("20.txt")[0..-2].split("\n\n")

    @tiles = tiles.map do |tile|
      rows = tile.split('\n')
      id = rows[0][5..8].to_i
      image = rows[1..-1].map(&.chars)
      { id, image }
    end.to_h
  end

  def top_edge_matches?(tile : Image, edge : String)
    top_edge = tile[0].join
    top_edge == edge
  end

  def left_edge_matches?(tile : Image, edge : String)
    left_edge = tile.map(&.first).join
    left_edge == edge
  end

  def rotate(tile : Image)
    tile.transpose.map(&.reverse)
  end

  def orientate(tile : Image, &block)
    2.times do
      return tile if yield tile
      3.times do
        tile = rotate(tile)
        return tile if yield tile
      end

      tile.each(&.reverse!)
    end
  end

  def find_sea_monsters(image : Image)
    sea_monster_pixels = [
      {0, 1}, {1, 2}, {4, 2}, {5, 1}, {6, 1},
      {7, 2}, {10, 2}, {11, 1}, {12, 1}, {13, 2},
      {16, 2}, {17, 1}, {18, 0}, {18, 1}, {19, 1}
    ]

    (0...image.size).sum do |y|
      (0...image[0].size).count do |x|
        sea_monster_pixels.all? { |i, j| image[y+j]? && image[y+j][x+i]? == '#' }
      end
    end
  end

  def execute
    edge_hash = Hash(String, Array(Int32)).new { |key| [] of Int32 }

    @tiles.each do |(tile_id, image)|
      # Edges reading clockwise
      [image[0].join, image[-1].join, image.map(&.first).join, image.map(&.last).join].each do |edge|
        key = edge < edge.reverse ? edge : edge.reverse

        edge_hash[key] = edge_hash[key].push(tile_id)
      end
    end

    # Unmatched edges
    unmatched_edges = edge_hash.keys.select { |edge| edge_hash[edge].size % 2 == 1 }

    # Corner tiles have 2 unmatched edges
    tile_unmatched_edge_count = Hash(Int32, Int32).new(0)
    unmatched_edges.each { |edge| edge_hash[edge].each { |tile_id| tile_unmatched_edge_count[tile_id] += 1 } }
    corner_tile_ids = tile_unmatched_edge_count.select { |tile_id, count| count == 2 }.keys

    # Part 1
    puts corner_tile_ids.product(1_i64)

    image = [] of Array(Char)

    # First tile
    tile_id = corner_tile_ids[0]
    first_tiles_per_column = [] of Tuple(Int32, Image)
    tile = @tiles[tile_id]
    start_left_edge, start_top_edge = unmatched_edges.select { |edge| edge_hash[edge].includes?(tile_id) }
    tile = orientate(tile) do |orientation|
      (left_edge_matches?(orientation, start_left_edge) || left_edge_matches?(orientation, start_left_edge.reverse)) &&
      (top_edge_matches?(orientation, start_top_edge) || top_edge_matches?(orientation, start_top_edge.reverse))
    end
    raise "No orientation found for initial tile" unless tile
    tile[1..-2].each { |row| image.push(row[1..-2].clone) }
    first_tiles_per_column.push({ tile_id, tile })

    # Rest of first column
    bottom_edge = tile[-1].join
    while !unmatched_edges.includes?(bottom_edge) && !unmatched_edges.includes?(bottom_edge.reverse)
      @tiles.each do |tid, t|
        next if tid == tile_id
        next_tile = orientate(t) { |o| top_edge_matches?(o, bottom_edge) }
        if next_tile
          tile, tile_id = next_tile, tid
          first_tiles_per_column.push({ tile_id, tile })
          tile[1..-2].each { |row| image.push(row[1..-2].clone) }
          bottom_edge = tile[-1].join
          break
        end
      end
    end

    # Rest of image
    start_row = 0
    first_tiles_per_column.each do |tile_id, tile|
      right_edge = tile.map(&.last).join
      while !unmatched_edges.includes?(right_edge) && !unmatched_edges.includes?(right_edge.reverse)
        right_edge = tile.map(&.last).join
        @tiles.each do |tid, t|
          next if tid == tile_id
          next_tile = orientate(t) { |o| left_edge_matches?(o, right_edge) }
          if next_tile
            tile, tile_id = next_tile, tid
            tile[1..-2].each_with_index { |row, idx| image[start_row + idx] += row[1..-2] }
            break
          end
        end
      end
      start_row += 8
    end

    # print_image(image)

    image = orientate(image) { |i| find_sea_monsters(i) > 0 }
    raise "No sea monsters found" unless image

    puts image.sum { |row| row.count('#') } - find_sea_monsters(image) * 15
  end

  def print_image(image : Image)
    image.each { |row| puts row.join }
  end
end

Program.new.execute
