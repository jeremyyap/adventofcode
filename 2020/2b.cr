inputs = File.read("2.txt").split("\n")[0..-2]

count = 0
inputs.each do |line|
  range, letter, password = line.split(' ')
  left, right = range.split('-').map(&.to_i)
  char = letter[0]

  count += 1 if (password[left - 1] == char) ^ (password[right - 1] == char)
end

puts count
