class Program
  @inputs: Array(Char)

  def initialize
    @inputs = File.read("6.txt").chomp.chars
  end

  def process(length : Int32)
    counts = Hash(Char, Int32).new(0)
    pos = 0

    loop do
      c = @inputs[pos]
      counts[c] += 1
      if (pos-length >= 0)
        cc = @inputs[pos-length]
        counts[cc] -= 1
        counts.delete(cc) if counts[cc] == 0
      end
      pos += 1
      return pos if counts.size == length
    end
  end

  def execute
    puts process(4)  # part 1
    puts process(14) # part 2
  end
end

Program.new.execute
