class Program
  @commands: Array(Tuple(Int32, Int32, Int32))
  @stacks: Array(Array(Char))

  def initialize
    raw_stacks, rows = File.read("5.txt").chomp.split("\n\n")
    @stacks = [] of Array(Char)
    raw_stacks.split("\n").each do |row|
      row.chars.each_slice(4).each_with_index do |slice, i|
        while @stacks.size < i+1
          @stacks << [] of Char
        end
        @stacks[i].unshift(slice[1]) if slice[1] != ' '
      end
    end

    @commands = rows.split("\n").map do |command|
      count, from, to = command.match(/move (\d+) from (\d+) to (\d+)/)
        .try(&.captures).not_nil!
        .map { |param| param.not_nil!.to_i }
      { count, from, to }
    end
  end

  def simulate(reverse : Bool)
    stacks = @stacks.clone
    @commands.each do |(count, from, to)|
      move = stacks[from - 1].pop(count)
      move.reverse! if (reverse)
      stacks[to - 1] += move
    end

    stacks.map { |stack| stack.last }.join
  end

  def execute
    puts simulate(true)
    puts simulate(false)
  end
end

Program.new.execute