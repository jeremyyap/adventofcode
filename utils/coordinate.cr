alias Coordinate = Tuple(Int32, Int32)

def print_image(hash : Hash(Coordinate, T)) forall T
  print_image(hash) { |coord, value| value }
end

def print_image(hash : Hash(Coordinate, T)) forall T
  min_row, max_row = hash.keys.map { |key| key[0] }.minmax
  min_col, max_col = hash.keys.map { |key| key[1] }.minmax

  image = Array.new(max_row - min_row + 1) { Array.new(max_col - min_col + 1, ' ') }

  hash.each do |coord, value|
    image[coord[0] - min_row][coord[1] - min_col] = yield coord, value
  end
  image.each { |row| puts row.join(' ') }
end
