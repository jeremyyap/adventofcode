require "./intcode"

input = Channel(Int64).new
output = Channel(Int64).new
instructions = File.read("11.txt").split(',').map(&.to_i64)

spawn do
  Intcode.new(instructions, input, output).execute
end

alias Coordinate = Tuple(Int32, Int32)

enum Color
  Black
  White
end

enum Direction
  Up
  Right
  Down
  Left
end

panels = Hash(Coordinate, Int32).new
location = { 0, 0 }
facing = Direction::Up.to_i
moveX = [0, 1, 0, -1]
moveY = [1, 0, -1, 0]
panels[location] = Color::White.to_i

spawn do
  while true
    input.send(panels.fetch(location, Color::Black.to_i64).to_i64)
    panels[location] = output.receive.to_i
    facing = output.receive == 1 ? (facing - 1) % 4 : (facing + 1) % 4
    location = { location[0] + moveX[facing], location[1] + moveY[facing] }
  end
end

Fiber.yield

min_x, max_x = panels.keys.map { |key| key[0] }.minmax
min_y, max_y = panels.keys.map { |key| key[1] }.minmax

image = Array.new(max_y - min_y + 1) { Array.new(max_x - min_x, ' ') }

panels.each { |coord, value| image[coord[1] - min_y][coord[0] - min_x] = '*' if value == Color::White.to_i }
image.each { |row| puts row.join(' ') }
