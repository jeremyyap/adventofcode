require "./intcode"

input = Channel(Int64).new
output = Channel(Int64).new
instructions = File.read("9.txt").split(',').map(&.to_i64)

# Part 1
spawn do
  Intcode.new(instructions, input, output).execute
end

input.send(1)
Fiber.yield
puts output.receive


# Part 2
spawn do
  Intcode.new(instructions, input, output).execute
end

input.send(2)
Fiber.yield
puts output.receive
