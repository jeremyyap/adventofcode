class Program
  @input: Array(Int32)

  def initialize
    @input = File.read("15.txt")[0..-2].split(',').map(&.to_i)
  end

  def find_nth(n)
    indexes = Hash(Int32, Int32).new
    gaps = Hash(Int32, Int32).new

    num = -1
    n.times do |idx|
      if @input[idx]? != nil
        num = @input[idx]
        indexes[num] = idx
        gaps[num] = 0
        next
      end

      num = gaps[num]

      if !indexes.has_key?(num)
        indexes[num] = idx
        gaps[num] = 0
      else
        gaps[num] = idx - indexes[num]
        indexes[num] = idx
      end
    end

    num
  end

  def execute
    # Part 1
    puts find_nth(2020)

    # Part 2
    puts find_nth(30000000)
  end
end

Program.new.execute
