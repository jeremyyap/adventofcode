class Program
  @inputs: Array(Int64)

  def initialize
    @inputs = File.read("9.txt")[0..-2].split.map(&.to_i64)
  end

  def part_1
    window = @inputs[0..24]
    @inputs[25..-1].each_with_index do |target|
      return target unless window.combinations(2).to_a.any? { |(x, y)| x + y == target }
      window.shift()
      window.push(target)
    end

    raise "No answer found."
  end

  def part_2
    target = part_1
    sum = 0_i64
    window = [] of Int64

    @inputs.each do |number|
      sum += number
      window.push(number)

      while sum > target
        sum -= window.shift()
      end

      return window.min + window.max if sum == target
    end

    raise "No answer found."
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
