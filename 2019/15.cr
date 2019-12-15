require "./intcode"

input = Channel(Int64).new
output = Channel(Int64).new
instructions = File.read("15.txt").split(',').map(&.to_i64)

alias Coordinate = Tuple(Int32, Int32)

enum Direction
  North
  South
  West
  East
end

enum Cell
  Wall
  Empty
  Oxygen
  Unexplored
end

def opposite(direction : Direction)
  case direction
  when Direction::North
    Direction::South
  when Direction::South
    Direction::North
  when Direction::West
    Direction::East
  else
    Direction::West
  end
end

def possible_moves(location : Coordinate)
  moveX = [0, 0, -1, 1]
  moveY = [1, -1, 0, 0]

  Direction.values.map do |move|
    { location[0] + moveX[move.to_i], location[1] + moveY[move.to_i] }
  end
end

spawn do
  Intcode.new(instructions, input, output).execute
end

map = Hash(Coordinate, Cell).new
depths = Hash(Coordinate, Int32).new
location = { 0, 0 }
next_location = { 0, 1 }
direction = Direction::North
map[location] = Cell::Empty
depths[location] = 0
oxygen_location = { 0, 0 }

10000.times do
  input.send(direction.to_i64 + 1) # Enum starts from 0 instead of 1
  cell = Cell.new(output.receive.to_i)

  map[next_location] = cell
  case cell
  when Cell::Wall
    depths[next_location] = 99999
  when Cell::Empty
    depths[next_location] = [depths.fetch(next_location, 99999), depths[location] + 1].min
    location = next_location
  when Cell::Oxygen
    depths[next_location] = [depths.fetch(next_location, 99999), depths[location] + 1].min
    location = next_location
    oxygen_location = location
  end

  all_explored = true
  possible_moves(location).each_with_index do |move, index|
    if !map.has_key?(move)
      next_location = move
      direction = index
      all_explored = false
      break;
    end
  end

  if all_explored
    direction = Direction.values.min_by do |move|
      possible_move = possible_moves(location)[move.to_i]
      depths[possible_move]
    end
    next_location = possible_moves(location)[direction.to_i]
  end
end

min_x, max_x = map.keys.map { |key| key[0] }.minmax
min_y, max_y = map.keys.map { |key| key[1] }.minmax

image = Array.new(max_y - min_y + 1) { Array.new(max_x - min_x + 1, ' ') }

map.each do |coord, value|
  image[coord[1] - min_y][coord[0] - min_x] = case value
  when Cell::Wall
    '#'
  when Cell::Empty
    coord == {0,0} ? 'D' : '.'
  else
    'O'
  end
end
image.each { |row| puts row.join(' ') }

puts depths[oxygen_location]

depths = Hash(Coordinate, Int32).new
depths[oxygen_location] = 0

queue = [oxygen_location]
while !queue.empty?
  current = queue.shift
  Direction.each do |direction|
    possible_move = possible_moves(current)[direction.to_i]
    if map.fetch(possible_move, Cell::Wall) != Cell::Wall && !depths.has_key?(possible_move)
      queue.push(possible_move)
      depths[possible_move] = depths[current] + 1
    end
  end
end

puts depths.values.max
