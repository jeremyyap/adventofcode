class Program
  @inputs: Array(String)

  def initialize
    @inputs = @inputs = File.read("5.txt").chomp.split
  end

  def to_seat_id(str : String)
    str.chars.map do |char|
      case char
        when 'F', 'L'
          0
        else # 'B', 'R'
          1
      end
    end.join.to_i(2)
  end

  def execute
    set = Set(Int32).new
    min = Int32::MAX
    max = 0
    @inputs.map { |input| to_seat_id(input) }.each do |seat_id|
      min = [min, seat_id].min
      max = [max, seat_id].max
      set.add(seat_id)
    end

    # Part 1
    puts max

    # Part 2
    (min..max).each do |seat_id|
      puts seat_id if !set.includes?(seat_id)
    end
  end
end

Program.new.execute
