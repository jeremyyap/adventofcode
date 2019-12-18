require "./intcode"
require "../utils/coordinate"

input = Channel(Int64).new
output = Channel(Int64).new
instructions = File.read("11.txt").split(',').map(&.to_i64)

spawn do
  Intcode.new(instructions, input, output).execute
end

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

panels = Hash(Coordinate, Int32).new { Color::Black.to_i }
location = { 0, 0 }
facing = Direction::Up.to_i
moveX = [0, 1, 0, -1]
moveY = [1, 0, -1, 0]
panels[location] = Color::White.to_i

spawn do
  while true
    input.send(panels[location].to_i64)
    panels[location] = output.receive.to_i
    facing = output.receive == 1 ? (facing - 1) % 4 : (facing + 1) % 4
    location = { location[0] + moveX[facing], location[1] + moveY[facing] }
  end
end

Fiber.yield

print_image(panels) { |coord, value| value == Color::White.to_i ? '*' : ' ' }
