inputs = File.read("1.txt").split.map(&.to_i)

set = Set(Int32).new
inputs.each_with_index do |x, i|
  inputs.each_with_index do |y, j|
    if (j > i)
      z = 2020 - x - y
      puts x * y * z if set.includes?(z)
    end
  end

  set.add(x)
end
