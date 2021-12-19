class Program
  @input : Array(String)

  def initialize
    @input = File.read("18.txt").chomp.split('\n')
  end

  def part_1
    sum = 0_i64
    @input.each do |line|
      stack = [0_i64]
      op_stack = ['+']
      line.chars.select { |char| char != ' ' }.each do |char|
        if char == '('
          stack << 0_i64
          op_stack << '+'
        elsif char == ')'
          value = stack.pop
          op = op_stack.pop
          stack[-1] = op == '+' ? stack[-1] + value : stack[-1] * value
        elsif char == '+' || char == '*'
          op_stack << char
        else
          value = char - '0'
          op = op_stack.pop
          stack[-1] = op == '+' ? stack[-1] + value : stack[-1] * value
        end
      end
      sum += stack[0]
    end
    sum
  end

  def part_2
    sum = 0_i64
    @input.each do |line|
      stack = [] of Int64
      op_stack = [] of Char
      line.chars.select { |char| char != ' ' }.each do |char|
        if char == '(' || char == '+' || char == '*'
          op_stack.push(char)
        elsif char == ')'
          while op_stack.last != '('
            a = stack.pop
            b = stack.pop
            op = op_stack.pop
            stack.push(op == '+' ? a + b : a * b)
          end
          op_stack.pop
          while op_stack.last? == '+'
            op = op_stack.pop
            a = stack.pop
            b = stack.pop
            stack.push(op == '+' ? a + b : a * b)
          end
        else
          b = char - '0'
          if op_stack.last? == '+'
            op_stack.pop
            a = stack.pop
            stack.push(a + b)
          else
            stack.push(b.to_i64)
          end
        end
      end

      while op_stack.last? == '*'
        op = op_stack.pop
        a = stack.pop
        b = stack.pop
        stack.push(op == '+' ? a + b : a * b)
      end
      sum += stack[0]
    end
    sum
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
