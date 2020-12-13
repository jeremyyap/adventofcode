require "big"

class Program
  @input: Array(String)

  def initialize
    @input = File.read("13.txt")[0..-2].split
  end

  def extended_gcd(a, b)
    last_remainder, remainder = a.abs, b.abs
    x, last_x, y, last_y = 0, 1, 1, 0
    while remainder != 0
      last_last_remainder = last_remainder
      last_remainder = remainder
      quotient, remainder = last_last_remainder.divmod(last_remainder)
      x, last_x = last_x - quotient*x, x
      y, last_y = last_y - quotient*y, y
    end

    return last_remainder, last_x * (a < 0 ? -1 : 1)
  end

  def invmod(e, et)
    g, x = extended_gcd(e, et)
    if g != 1
      raise "The maths are broken!"
    end
    x % et
  end

  def chinese_remainder(buses)
    # Product of all bus frequencies
    lcm = buses.product { |bus| bus[0] }
    # For each bus, find x such that x is divisible by all other bus frequencies and x ≡ r (mod m)
    # k * lcm/m ≡ r (mod m)
    # k = r * invmod(lcm/m, m)
    terms = buses.map { |m, r| (r * invmod(lcm//m, m) * lcm // m) }
    # Find the earliest such timing
    terms.sum % lcm
  end

  def part_1
    min_departure = @input[0].to_i
    buses = @input[1].split(',').select { |str| str != "x" }.map(&.to_i)

    min = Int32::MAX
    bus_id = -1
    buses.each do |bus|
      wait_time = bus - (min_departure % bus)
      min = [wait_time, min].min
      bus_id = bus if min == wait_time
    end

    bus_id * min
  end

  def part_2
    timings = @input[1].split(',')
    buses = [] of Tuple(BigInt, BigInt)
    timings.each_with_index do |bus, i|
      next if bus == "x"
      modulo = BigInt.new(bus)
      remainder = (-i) % modulo
      buses.push({ modulo, remainder })
    end

    chinese_remainder(buses)
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
