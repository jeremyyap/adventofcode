class Program
  @inputs: Array(Tuple(String, Int32))

  def initialize
    @inputs = File.read("10.txt").chomp.split("\n").map do |row|
      args = row.split(' ')
      amt = args[1]? ? args[1].to_i : 0
      { args[0], amt }
    end
  end

  def part_1
    interesting_cycles = [20, 60, 100, 140, 180, 220]
    sum = 0
    cycle = 1
    x = 1
    @inputs.each do |cmd|
      sum += x * cycle if interesting_cycles.includes?(cycle)
      if cmd[0] == "noop"
        cycle += 1
      else
        cycle += 1
        sum += x * cycle if interesting_cycles.includes?(cycle)
        cycle += 1
        x += cmd[1]
      end
    end
    sum
  end

  def part_2
    cycle = 0
    x = 1
    board = Array.new(6) { Array.new(40) { '.' } }
    @inputs.each do |cmd|
      break if cycle >= 240
      board[cycle // 40][cycle % 40] = '*' if ((cycle % 40) - x).abs <= 1
      if cmd[0] == "noop"
        cycle += 1
      else
        cycle += 1
        board[cycle // 40][cycle % 40] = '*' if ((cycle % 40) - x).abs <= 1
        cycle += 1
        x += cmd[1]
      end
    end
    board.map { |row| puts row.join }
  end

  def execute
    puts part_1
    part_2
  end
end

Program.new.execute
