class Program
  @inputs: Array(String)
  @bits: Int32

  def initialize
    @inputs = File.read("3.txt").split
    @bits = @inputs[0].size
  end

  def select_bit(inputs : Enumerable(String), i : Int32)
    zeroes_count = inputs.count { |line| line.chars[i] == '0' }
    ones_count = inputs.count { |line| line.chars[i] == '1' }
    (yield zeroes_count, ones_count) ? '1' : '0'
  end

  def part_1
    gamma = 0.upto(@bits - 1).map do |i|
      select_bit(@inputs, i) { |zeroes, ones| ones > zeroes }
    end.to_a.join.to_i(2)

    epsilon = 0.upto(@bits - 1).map do |i|
      select_bit(@inputs, i) { |zeroes, ones| ones < zeroes }
    end.to_a.join.to_i(2)

    gamma * epsilon
  end

  def oxygen_generator_rating
    set = @inputs.to_set
    0.upto(@bits - 1) do |i|
      target = select_bit(set, i) { |zeroes, ones| ones >= zeroes }
      set = set.select { |line| line.chars[i] == target }
      return set[0].to_i(2) if set.size == 1
    end
    raise "Error"
  end

  def co2_scrubber_rating
    set = @inputs.to_set
    0.upto(@bits - 1) do |i|
      target = select_bit(set, i) { |zeroes, ones| ones < zeroes }
      set = set.select { |line| line.chars[i] == target }
      return set[0].to_i(2) if set.size == 1
    end
    raise "Error"
  end

  def part_2
    return oxygen_generator_rating * co2_scrubber_rating
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
