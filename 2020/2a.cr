inputs = File.read("2.txt").split("\n")[0..-2]

count = 0
inputs.each do |line|
  range, letter, password = line.split(' ')
  min, max = range.split('-').map(&.to_i)
  char = letter[0]

  occurrences = password.chars.count(char)
  count += 1 if min <= occurrences && occurrences <= max
end

puts count
