class Program
  @inputs: Array(Array(Char))

  def initialize
    @inputs = File.read("10.txt").chomp.split("\n").map { |line| line.chars }
  end

  @@pairs_map = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }

  def part_1
    points_map = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }

    @inputs.sum do |chars|
      stack = [] of Char
      score = 0
      chars.each do |c|
        if @@pairs_map.keys.includes?(c)
          stack.push(@@pairs_map[c])
        else
          break score = points_map[c] if stack.pop() != c
        end
      end
      score
    end
  end

  def part_2
    points_map = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }

    scores = @inputs.map do |chars|
      stack = [] of Char
      corrupted = false
      chars.each do |c|
        if @@pairs_map.keys.includes?(c)
          stack.push(@@pairs_map[c])
        else
          break corrupted = true if stack.pop() != c
        end
      end

      stack.reverse.reduce(0_i64) { |score, c| score * 5 + points_map[c] } unless corrupted
    end.compact.sort

    scores[scores.size // 2]
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
