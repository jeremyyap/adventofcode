require "./intcode"
require "../utils/coordinate"

def test(x : Int32, y : Int32)
  input = Channel(Int64).new
  output = Channel(Int64).new
  instructions = File.read("19.txt").split(',').map(&.to_i64)
  spawn do
    Intcode.new(instructions, input, output).execute
  end

  input.send x.to_i64
  input.send y.to_i64
  return output.receive == 1
end

# Part 1

count = 0
(0..49).each do |x|
  (0..49).each do |y|
    count += test(x, y) ? 1 : 0
  end
end

puts count

# Part 2

def testSquare(x : Int32, y : Int32) # Bottom left corner
  test(x, y) && test(x + 99, y - 99)
end

x, y = 0, 99
while true
  if test(x,y)
    if testSquare(x,y)
      puts x * 10000 + y - 99
      break
    end
    y += 1
  else
    x += 1
  end
end
