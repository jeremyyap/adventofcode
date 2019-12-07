def segments(wire)
  horizontal_wires = [] of Array(Int32)
  vertical_wires = [] of Array(Int32)

  prev = [0, 0]
  wire.each do |part|
    dir = part[0]
    distance = part[1..-1].to_i
    case dir
      when 'U'
        current = [prev[0], prev[1] + distance]
        vertical_wires.push([prev[0], prev[1], current[1]])
      when 'D'
        current = [prev[0], prev[1] - distance]
        vertical_wires.push([prev[0], current[1], prev[1]])
      when 'L'
        current = [prev[0] - distance, prev[1]]
        horizontal_wires.push([prev[1], current[0], prev[0]])
      when 'R'
        current = [prev[0] + distance, prev[1]]
        horizontal_wires.push([prev[1], prev[0], current[0]])
      else
        raise "Invalid direction"
    end

    prev = current
  end

  return [horizontal_wires, vertical_wires]
end

inputs = File.read("3.txt").split.map { |line| line.split(',') }

horizontals_1, verticals_1 = segments(inputs[0])
horizontals_2, verticals_2 = segments(inputs[1])

def find_min(horizontals, verticals)
  min_distance = 2 ** 30

  horizontals.each do |h|
    verticals.each do |v|
      if v[1] < h[0] && h[0] < v[2] && h[1] < v[0] && v[0] < h[2]
        min_distance = [min_distance, h[0].abs + v[0].abs].min
      end
    end
  end
  min_distance
end

puts [find_min(horizontals_1, verticals_2), find_min(horizontals_2, verticals_1)].min
