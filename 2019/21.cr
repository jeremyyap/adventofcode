require "./intcode"
require "../utils/coordinate"

input = Channel(Int64).new
output = Channel(Int64).new
instructions = File.read("21.txt").split(',').map(&.to_i64)

def read_prompt(output)
  while (number = output.receive) != 10
    print number.chr
  end
  print ' '
end

def read_output(output)
  while (number = output.receive) < 128
    print number.chr
  end
  puts number
end

# Part 1
spawn do
  Intcode.new(instructions, input, output).execute
end

# !(!!A && B && C) && D
commands = [
  "NOT A J\n",
  "NOT J J\n",
  "AND B J\n",
  "AND C J\n",
  "NOT J J\n",
  "AND D J\n",
  "WALK\n"
]

read_prompt(output)
commands.each do |command|
  command.each_char { |char| input.send char.ord.to_i64 }
end
read_output(output)

# !(!!A && B && C) && D && !(!E && !H)
spawn do
  Intcode.new(instructions, input, output).execute
end

commands = [
  "NOT E T\n",
  "NOT H J\n",
  "AND T J\n",
  "NOT J J\n",
  "AND D J\n",
  "NOT A T\n",
  "NOT T T\n",
  "AND B T\n",
  "AND C T\n",
  "NOT T T\n",
  "AND T J\n",
  "RUN\n"
]

read_prompt(output)
commands.each do |command|
  command.each_char { |char| input.send char.ord.to_i64 }
end
read_output(output)
