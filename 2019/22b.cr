class Program
  def initialize(deck_size, power, target)
    @process = File.read("22.txt")[0..-2].split("\n").reverse
    @deck_size = deck_size
    @power = power
    @target = target
    @offset = 0
    @multiplier = 1
  end

  def deal_into_new_stack
    @offset = (@deck_size - @offset - 1) % @deck_size
    @multiplier = -@multiplier
  end

  def deal_with_increment(inc)
    mult = invmod(inc, @deck_size)
    @multiplier = (@multiplier * mult) % @deck_size
    @offset = (@offset * mult) % @deck_size
  end

  def cut(cut)
    @offset = (@offset + cut) % @deck_size
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

  def shuffle
    @process.each do |step|
      words = step.split(' ')
      if step == "deal into new stack"
        deal_into_new_stack
      elsif words[0] == "cut"
        cut(words[-1].to_i)
      else
        deal_with_increment(words[-1].to_i)
      end
    end
  end

  def execute
    shuffle
    (@multiplier.pow(@power, @deck_size) * @target + @offset * (@multiplier.pow(@power, @deck_size) - 1) * invmod(@multiplier - 1, @deck_size)) % @deck_size
  end
end

puts Program.new(119315717514047, 101741582076661, 2020).execute
