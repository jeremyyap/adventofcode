inputs = File.read("1.txt").split.map(&.to_i)

fuels = inputs.map do |x|
  sum = 0
  x = x // 3 - 2
  while x > 0
    sum += x
    x = x // 3 - 2
  end
  sum
end

puts fuels.sum
