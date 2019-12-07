def segments(wire)
  horizontal_wires = [] of Array(Int32)
  vertical_wires = [] of Array(Int32)

  prev = [0, 0]
  steps = 0
  wire.each do |part|
    dir = part[0]
    length = part[1..-1].to_i
    case dir
      when 'U'
        current = [prev[0], prev[1] + length]
        vertical_wires.push([prev[0], prev[1], current[1], steps])
      when 'D'
        current = [prev[0], prev[1] - length]
        vertical_wires.push([prev[0], prev[1], current[1], steps])
      when 'L'
        current = [prev[0] - length, prev[1]]
        horizontal_wires.push([prev[1], prev[0], current[0], steps])
      when 'R'
        current = [prev[0] + length, prev[1]]
        horizontal_wires.push([prev[1], prev[0], current[0], steps])
      else
        raise "Invalid direction"
    end

    steps += length
    prev = current
  end

  return [horizontal_wires, vertical_wires]
end

def between?(value, bound1, bound2)
  min, max = bound1 < bound2 ? [bound1, bound2] : [bound2, bound1]
  min < value && value < max
end

def find_min(horizontals, verticals)
  min_distance = 2 ** 30

  horizontals.each do |h|
    verticals.each do |v|
      if between?(h[0], v[1], v[2]) && between?(v[0], h[1], h[2])
        intersection = h[3] + v[3] + (h[1] - v[0]).abs + (v[1] - h[0]).abs
        min_distance = [min_distance, intersection].min if intersection > 0
      end
    end
  end
  min_distance
end

inputs = File.read("3.txt").split.map { |line| line.split(',') }

horizontals_1, verticals_1 = segments(inputs[0])
horizontals_2, verticals_2 = segments(inputs[1])

puts [find_min(horizontals_1, verticals_2), find_min(horizontals_2, verticals_1)].min
