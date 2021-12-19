class Program
  @instructions: Array(String)
  @backup: Array(String)

  def initialize
    @instructions = File.read("8.txt").chomp.split('\n')
    @backup = @instructions.clone
  end

  def run_code
    visited = Set(Int32).new
    acc = 0
    pc = 0

    while !visited.includes?(pc) && pc < @instructions.size
      visited.add(pc)
      instr = @instructions[pc]
      cmd, val = instr.split(" ")
      acc += val.to_i if cmd == "acc"
      pc += val.to_i if cmd == "jmp"
      pc +=1 if cmd != "jmp"
    end

    return acc, pc == @instructions.size
  end

  def part_1
    acc, _ = run_code
    acc
  end

  def part_2
    @backup.each_with_index do |instr, idx|
      @instructions = @backup.clone
      cmd, val = instr.split(" ")
      @instructions[idx] = "jmp " + val if cmd == "nop"
      @instructions[idx] = "nop " + val if cmd == "jmp"

      acc, terminated = run_code
      return acc if terminated
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
