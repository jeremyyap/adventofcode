inputs = File.read("1.txt").split.map(&.to_i)

set = Set(Int32).new
inputs.each do |x|
  y = 2020 - x
  if set.includes?(y)
    puts y * x
    break
  end

  set.add(x)
end
