class Moon
  property vx
  property vy
  property vz
  property x : Int32
  property y : Int32
  property z : Int32

  def initialize(@x, @y, @z)
    @vx = 0
    @vy = 0
    @vz = 0
  end
end

moons = [
  Moon.new(16, -11, 2),
  Moon.new(0, -4, 7),
  Moon.new(6, 4, -10),
  Moon.new(-3, -2, -4)
]

def step_velocity(moon1 : Moon, moon2 : Moon)
  dx = moon1.x <=> moon2.x
  dy = moon1.y <=> moon2.y
  dz = moon1.z <=> moon2.z

  moon1.vx -= dx
  moon2.vx += dx
  moon1.vy -= dy
  moon2.vy += dy
  moon1.vz -= dz
  moon2.vz += dz
end

def step(moon : Moon)
  moon.x += moon.vx
  moon.y += moon.vy
  moon.z += moon.vz
end

alias AxisState = Tuple(Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32)

def x_state(moons : Array(Moon))
  AxisState.from(moons.flat_map { |moon| [moon.x, moon.vx] })
end

def y_state(moons : Array(Moon))
  AxisState.from(moons.flat_map { |moon| [moon.y, moon.vy] })
end

def z_state(moons : Array(Moon))
  AxisState.from(moons.flat_map { |moon| [moon.z, moon.vz] })
end

x_set = Set(AxisState).new
y_set = Set(AxisState).new
z_set = Set(AxisState).new
x_set.add(x_state(moons))
y_set.add(y_state(moons))
z_set.add(z_state(moons))

x = 0
y = 0
z = 0

i = 0
while x == 0 || y == 0 || z == 0
  moons.each_with_index do |moon1, index|
    moons[(index + 1)..-1].each do |moon2|
      step_velocity(moon1, moon2)
    end
  end

  moons.each { |moon| step(moon) }
  i += 1

  x = i if x_set.includes?(x_state(moons)) && x == 0
  x_set.add(x_state(moons))
  y = i if y_set.includes?(y_state(moons)) && y == 0
  y_set.add(y_state(moons))
  z = i if z_set.includes?(z_state(moons)) && z == 0
  z_set.add(z_state(moons))
end

puts x, y, z
puts x.to_i64.lcm(y).lcm(z)

# total_energy = moons.map do |moon|
#   (moon.x.abs + moon.y.abs + moon.z.abs) * (moon.vx.abs + moon.vy.abs + moon.vz.abs)
# end.sum

# puts total_energy
