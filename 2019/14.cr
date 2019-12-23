alias Chemical = { Int64, String }

class Program
  def initialize()
    @hash = Hash(String, { Int64, Array(Chemical) }).new
    @count = 0

    inputs = File.read("14.txt").split('\n')[0..-2]
    inputs.each do |line|
      input_str, output_str = line.split(" => ")
      inputs = input_str.split(", ").map { |input| chemical(input) }
      output = chemical(output_str)
      @hash[output[1]] = { output[0], inputs }
    end
  end

  def chemical(input : String)
    qty, type = input.split(" ")
    { qty.to_i64, type }
  end

  def execute(fuel)
    requirements = Hash(String, Int64).new { 0 }
    requirements["FUEL"] = fuel.to_i64
    ore = 0_i64

    while requirements.values.any? { |v| v > 0 }
      requirements.each do |key, required_qty|
        if (required_qty > 0)
          output_qty, inputs = @hash[key]
          multiplier = (required_qty / output_qty).ceil.to_i64
          requirements[key] -= multiplier * output_qty
          inputs.each do |input_qty, type|
            if type == "ORE"
              ore += input_qty * multiplier
            else
              requirements[type] = requirements[type] + input_qty * multiplier
            end
          end
        end
      end
    end
    ore
  end
end

available_ore = 1000000000000

min = 0_i64
max = available_ore
mid = (min + max) / 2

while min != max
  mid = (min + max + 1) // 2
  if (available_ore <=> Program.new.execute(mid)) < 0
    max = mid - 1
  else
    min = mid
  end
end

puts max
