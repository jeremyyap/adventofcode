class Program
  @template: String
  @insertion_rules: Array(Tuple(Char, Char, Char))

  def initialize
    input = File.read("14.txt").chomp.split("\n\n")
    @template = input[0]
    @insertion_rules = input[1].split("\n").map do |line|
      { line[0], line[1], line[-1] }
    end
  end

  def polymerize(steps : Int32)
    pair_counts = Hash(Tuple(Char, Char), Int64).new(0_i64)
    @template.chars.each_cons(2) { |(a, b)| pair_counts[{a, b}] += 1 }

    steps.times do
      next_pair_counts = pair_counts.clone
      @insertion_rules.each do |rule|
        match_count = pair_counts[{ rule[0], rule[1] }]
        next_pair_counts[{ rule[0], rule[1] }] -= match_count
        next_pair_counts[{ rule[0], rule[2] }] += match_count
        next_pair_counts[{ rule[2], rule[1] }] += match_count
      end
      pair_counts = next_pair_counts
    end

    counts = Hash(Char, Int64).new(0)
    pair_counts.each { |(a, b), c| counts[a] += c; counts[b] += c }
    counts[@template[0]] += 1
    counts[@template[-1]] += 1
    counts.values.max // 2 - counts.values.min // 2
  end

  def execute
    puts polymerize(10)
    puts polymerize(40)
  end
end

Program.new.execute
