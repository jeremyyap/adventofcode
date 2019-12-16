# Part 1

input = File.read("16.txt")[0..-2]
phase = input.split("").map(&.to_i)
pattern = [0, 1, 0, -1]

100.times do |i|
  next_phase = phase.map_with_index do |_, idx|
    phase.map_with_index { |digit, pos| digit * pattern[(pos + 1) // (idx+1) % 4] }.sum.abs % 10
  end
  phase = next_phase
end

puts phase[0..7].join("")

# Part 2

message = input * 10000
offset = message[0..6].to_i
phase = message[offset..-1].split("").map(&.to_i64)

100.times do |i|
  sum = phase.sum % 10
  next_phase = phase.map_with_index do |digit, idx|
    new_digit = sum
    sum = (sum - digit) % 10
    new_digit
  end
  phase = next_phase
end

puts phase[0..7].join("")
