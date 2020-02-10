require "./intcode"

input = Channel(Int64).new
output = Channel(Int64).new
instructions = File.read("25.txt").split(',').map(&.to_i64)

def read_prompt(output)
  string = ""
  while (number = output.receive) != 10
    string += number.chr
  end
  string
end

spawn do
  Intcode.new(instructions, input, output).execute
end

while true
  string = read_prompt(output)
  puts string
  if string == "Command?"
    command = gets.not_nil!
    command.each_char { |char| input.send char.ord.to_i64 }
    input.send 10_i64
  end
end
