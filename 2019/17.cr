require "./intcode"
require "../utils/coordinate"

input = Channel(Int64).new
output = Channel(Int64).new
instructions = File.read("17.txt").split(',').map(&.to_i64)
instructions[0] = 2

spawn do
  Intcode.new(instructions, input, output).execute
end

def read_map(output)
  map = Hash(Coordinate, Char).new
  row = 0
  col = 0
  while true
    number = output.receive
    break if number == 10 && col == 0

    if number == 10
      row += 1
      col = 0
    else
      map[{row,col}] = number.as(Int64).chr
      col += 1
    end
  end
  map
end

map = read_map(output)
sum = 0
map.each do |coordinate, value|
  row, col = coordinate
  if value == '#' &&
    map.fetch({row-1,col}, '.') == '#' &&
    map.fetch({row+1,col}, '.') == '#' &&
    map.fetch({row,col-1}, '.') == '#' &&
    map.fetch({row,col+1}, '.') == '#'
    sum += (row) * (col)
  end
end

print_image(map)
puts sum

# Part 2

# position =

# image.each_with_index do |row, i|
#   row.each_with_index do |cell, j|
#     if image[i][j] == '^'
#   end
# end

def read_prompt(output)
  while (number = output.receive) != 10
    print number.chr
  end
  print ' '
end

functions = [
  "A,B,A,C,B,A,C,B,A,C\n",
  "L,12,L,12,L,6,L,6\n",
  "R,8,R,4,L,12\n",
  "L,12,L,6,R,12,R,8\n",
  "n\n"
]

functions.each do |function|
  read_prompt(output)
  puts function
  function.each_char { |char| input.send char.ord.to_i64 }
end
puts output.receive.chr

map = read_map(output)
print_image(map)

puts output.receive
