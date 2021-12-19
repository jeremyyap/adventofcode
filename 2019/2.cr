require "./intcode"

class Program
  @instructions: Array(Int64)

  def initialize
    @instructions = File.read("2.txt").chomp.split(',').map(&.to_i64)
  end

  def run(noun : Int64, verb : Int64)
    instructions = @instructions.clone
    instructions[1] = noun
    instructions[2] = verb
    Intcode.new(instructions).execute
    instructions[0]
  end

  def part_1
    run(12, 2)
  end

  def part_2
    (1..99).each do |i|
      (1..99).each do |j|
        if run(i.to_i64, j.to_i64) == 19690720
          return 100 * i + j
        end
      end
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
