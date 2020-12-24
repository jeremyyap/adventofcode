class Program
  @tiles : Array(Array(String))

  def initialize
    @tiles = File.read("24.txt")[0..-2].split("\n").map { |tile| tile.split(/(se|sw|ne|nw|e|w)/).reject("") }
  end

  def execute
    tile_set = Set(Tuple(Int32, Int32)).new

    @tiles.each do |tile|
      x, y = 0, 0
      tile.each do |step|
        case step
        when "se"
          y -= 1
          x += 1
        when "sw"
          y -= 1
        when "ne"
          y += 1
        when "nw"
          y += 1
          x -= 1
        when "e"
          x += 1
        when "w"
          x -= 1
        end
      end
      tile_set.includes?({x, y}) ? tile_set.delete({x, y}) : tile_set.add({x, y})
    end

    # Part 1
    puts tile_set.size

    100.times do
      black_counts = Hash(Tuple(Int32, Int32), Int32).new(0)
      tile_set.each do |tile|
        [{1, -1}, {0, -1}, {0, 1}, {-1, 1}, {1, 0}, {-1, 0}].each do |dx, dy|
          black_counts[{tile[0] + dx, tile[1] + dy }] += 1
        end
      end

      white_to_black = black_counts.select { |_, count| count == 2 }.keys.to_set
      black_to_white = tile_set.select { |tile| black_counts[tile] == 0 || black_counts[tile] > 2 }.to_set
      tile_set = tile_set - black_to_white + white_to_black
    end

    # Part 2
    puts tile_set.size
  end
end

Program.new.execute
