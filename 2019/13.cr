require "./intcode"
require "../utils/coordinate"

input = Channel(Int64).new
output = Channel(Int64).new
instructions = File.read("13.txt").split(',').map(&.to_i64)
instructions[0] = 2

enum Tile
  Empty
  Wall
  Block
  Paddle
  Ball
end

screen = Hash(Coordinate, Tile).new { Tile::Empty }

spawn do
  Intcode.new(instructions, input, output).execute
end

block_count = 0
ball_pos = { -1, -1 }
paddle_pos = { -1, -1 }
ball_velocity = { -1, -1 }
score = 0

spawn do
  while true
    x = output.receive.to_i
    y = output.receive.to_i
    value = output.receive.to_i

    if x == -1 && y == 0
      score = value
    else
      pixel = {x, y}
      old_tile = screen[pixel]
      new_tile = Tile.new(value)
      screen[pixel] = new_tile

      block_count += 1 if new_tile == Tile::Block && old_tile != Tile::Block
      block_count -= 1 if old_tile == Tile::Block && new_tile != Tile::Block

      if new_tile == Tile::Ball
        ball_velocity = { pixel[0] - ball_pos[0], pixel[1] - ball_pos[1] }
        ball_pos = pixel
      end
      paddle_pos = pixel if new_tile == Tile::Paddle
    end
  end
end

while block_count > 0 || score == 0
  Fiber.yield
  input.send((ball_pos[0] <=> paddle_pos[0]).to_i64) if block_count > 0
end

puts block_count
puts score
