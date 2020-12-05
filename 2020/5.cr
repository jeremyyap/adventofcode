class Program
  @inputs: Array(String)

  def initialize
    @inputs = @inputs = File.read("5.txt").split
  end

  def to_binary(str : String)
    str.chars.map do |char|
      case char
        when 'F', 'L'
          0
        else # 'B', 'R'
          1
      end
    end.join
  end

  def execute
    set = Set(Int32).new
    min = Int32::MAX
    max = 0
    @inputs.map { |input| to_binary(input) }.each do |input|
      row = (input[0..6]).to_i(2)
      col = (input[7..-1]).to_i(2)
      seatId = row * 8 + col
      min = [min, seatId].min
      max = [max, seatId].max
      set.add(seatId)
    end

    # Part 1
    puts max

    # Part 2
    (min..max).each do |seatId|
      puts seatId if !set.includes?(seatId)
    end
  end
end

Program.new.execute
