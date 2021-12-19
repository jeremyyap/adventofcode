class SFNumber
  getter left, right : SFNumber | Int32

  @left: SFNumber | Int32
  @right: SFNumber | Int32

  def initialize(@left : SFNumber | Int32, @right : SFNumber| Int32); end
end

class Program
  @numbers: Array(SFNumber)

  def initialize
    inputs = File.read("18.txt").chomp.split("\n")
    @numbers = inputs.map { |line| parse(line).as(SFNumber) }
  end

  def parse(str)
    return str.to_i if str.size == 1

    depth = 0
    comma_idx = -1
    str.chars.each_with_index do |c, i|
      depth += 1 if c == '['
      depth -= 1 if c == ']'
      break comma_idx = i if c == ',' && depth == 1
    end

    SFNumber.new(parse(str[1...comma_idx]), parse(str[(comma_idx+1)...-1]))
  end

  def reduce_split(n : Int32)
    return SFNumber.new(n // 2, n - n // 2), true if n > 9
    return n, false
  end

  def reduce_split(n : SFNumber)
    right = n.right
    left, changed = reduce_split(n.left)
    right, changed = reduce_split(n.right) unless changed

    return SFNumber.new(left, right), changed
  end

  def increment_last(n, carry)
    return n + carry if n.is_a? Int32
    return SFNumber.new(n.left, increment_last(n.right, carry))
  end

  def increment_first(n, carry)
    return n + carry if n.is_a? Int32
    return SFNumber.new(increment_first(n.left, carry), n.right)
  end

  def reduce_explode(n : SFNumber | Int32, depth)
    return n, false, 0, 0 if n.is_a? Int32
    return 0, true, n.left.as(Int32), n.right.as(Int32) if depth > 4

    right, carry_right, right_changed = n.right, 0, false
    left, left_changed, carry_left, carry_right = reduce_explode(n.left, depth + 1)
    right, right_changed, carry_left, carry_right = reduce_explode(n.right, depth + 1) unless left_changed
    left, carry_left = increment_last(left, carry_left), 0 if right_changed
    right, carry_right = increment_first(right, carry_right), 0 if left_changed

    return SFNumber.new(left, right), left_changed || right_changed, carry_left, carry_right
  end

  def reduce(n : SFNumber)
    changed = true
    until changed == false
      n, changed, _, _ = reduce_explode(n, 1)
      n, changed = reduce_split(n) unless changed
    end
    n
  end

  def add(m, n)
    reduce(SFNumber.new(m, n))
  end

  def magnitude(n)
    return n if n.is_a? Int32
    3 * magnitude(n.left) + 2 * magnitude(n.right)
  end

  def execute
    puts magnitude(@numbers.reduce { |sum, n| add(sum, n) })               # part 1
    puts @numbers.permutations(2).max_of { |(a, b)| magnitude(add(a, b)) } # part 2
  end
end

Program.new.execute
