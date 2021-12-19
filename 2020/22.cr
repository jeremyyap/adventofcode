class Program
  @input : Array(String)

  def initialize
    @input = File.read("22.txt").chomp.split("\n\n")
  end

  def score(d1, d2)
    deck = d1.empty? ? d2 : d1
    score = deck.reverse.each_with_index.sum { |card, idx| card * (idx + 1) }
  end

  def part_1
    d1 = @input[0].split("\n")[1..-1].map(&.to_i)
    d2 = @input[1].split("\n")[1..-1].map(&.to_i)

    while !d1.empty? && !d2.empty?
      c1 = d1.shift
      c2 = d2.shift

      if c1 > c2
        d1 += [c1, c2]
      else
        d2 += [c2, c1]
      end
    end

    score(d1, d2)
  end

  def play(d1, d2) : Bool # P1 wins
    states = Set(Tuple(Array(Int32), Array(Int32))).new
    while !d1.empty? && !d2.empty?
      return true if states.includes?({ d1, d2 })
      states.add({ d1.clone, d2.clone })
      c1 = d1.shift
      c2 = d2.shift

      p1_win = c1 > c2
      if d1.size >= c1 && d2.size >= c2
        p1_win = play(d1.clone[0...c1], d2.clone[0...c2])
      end

      if p1_win
        d1.push(c1, c2)
      else
        d2.push(c2, c1)
      end
    end
    d1.empty? ? false : true
  end

  def part_2
    p1 = @input[0].split("\n")[1..-1].map(&.to_i)
    p2 = @input[1].split("\n")[1..-1].map(&.to_i)
    play(p1, p2)
    score(p1, p2)
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
