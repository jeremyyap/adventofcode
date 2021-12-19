require "./intcode"

class Program
  @instructions: Array(Int64)
  @input: Channel(Int64)
  @output: Channel(Int64)

  def initialize
    @instructions = File.read("5.txt").chomp.split(',').map(&.to_i64)
    @input = Channel(Int64).new
    @output = Channel(Int64).new
  end

  def part_1
    instructions = @instructions.clone
    spawn { @input.send(1) }
    last = 0
    spawn { while last == 0 { last = @output.receive } end }
    Intcode.new(instructions, @input, @output).execute
    last
  end

  def part_2
    instructions = @instructions.clone
    spawn { @input.send(5) }
    spawn { Intcode.new(instructions, @input, @output).execute }
    @output.receive
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
