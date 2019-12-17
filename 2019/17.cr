require "./intcode"

input = Channel(Int64).new
output = Channel(Int64).new
instructions = File.read("17.txt").split(',').map(&.to_i64)
instructions[0] = 2

spawn do
  Intcode.new(instructions, input, output).execute
end

def read_image(output)
  image = Array.new(45) { Array.new(51, ' ') }
  row = 1
  col = 1
  while row <= 44
    number = output.receive

    if number == 10
      row += 1
      col = 1
    else
      image[row][col] = number.as(Int64).chr
      col += 1
    end
  end
  image
end

image = read_image(output)
sum = 0
image.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    if image[i][j] == '#' &&
      image[i-1][j] == '#' &&
      image[i+1][j] == '#' &&
      image[i][j-1] == '#' &&
      image[i][j+1] == '#'
      sum += (i-1) * (j-1)
    end
  end
end

image.each { |row| puts row.join("") }
puts sum
puts

# Part 2

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

image = read_image(output)
image.each { |row| puts row.join("") }

puts output.receive.chr
puts output.receive
