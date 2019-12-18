require "../utils/coordinate"

def gradient(a : Coordinate, b : Coordinate)
  dx = b[0] - a[0]
  dy = a[1] - b[1] # y-coordinate is reversed

  gcd = dx.gcd(dy)
  { dx // gcd, dy // gcd }
end

def angle(coord : Coordinate)
  result = Math.atan2(coord[0], coord[1]) # Sweep clockwise from top -> swap x and y
  result % (Math::PI * 2) # atan2 is negative in 3rd and 4th quadrant: (-Math::PI, Math::PI]
end

def distance(a : Coordinate, b : Coordinate)
  (b[0] - a[0]).abs + (b[1] - a[1]).abs
end

asteroids = [] of Coordinate
map = File.read("10.txt").split.map(&.chars)
map.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    if cell == '#'
      asteroids.push({ x, y })
    end
  end
end

# Part 1
max = 0
location = { 0, 0 }

asteroids.each_with_index do |station, i|
  gradients = Set(Coordinate).new

  asteroids.each_with_index do |target, j|
    next if i == j
    gradients.add(gradient(station, target))
  end

  if gradients.size > max
    max = gradients.size
    location = station
  end
end

puts max
puts location

# Part 2
asteroids.delete(location)

hash = Hash(Coordinate, Array(Coordinate)).new

asteroids.each_with_index do |asteroid|
  key = gradient(location, asteroid)
  hash[key] = hash.fetch(key, [] of Coordinate).push(asteroid)
end

hash.each_key do |key|
  hash[key].sort! { |a, b| (a[0] - location[0]).abs <=> (b[0] - location[0]).abs }
end

sorted_keys = hash.keys.sort { |a, b| angle(a) <=> angle(b) }

i = 0
done = false
while !done
  sorted_keys.each do |key|
    next if hash[key].empty?
    asteroid = hash[key].shift
    i += 1
    if (i == 200)
      puts asteroid[0] * 100 + asteroid[1]
      done = true
      break
    end
  end
end
