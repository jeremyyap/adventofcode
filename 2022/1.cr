class Program
  @inputs: Array(Tuple)

  def initialize
    elves = File.read("1.txt").chomp.split("\n\n")
    @inputs = elves.map { |elf| elf.split.map(&.to_i) }
  end

  def part_1
    @inputs.max_of { |elf| elf.sum }
  end

  def part_2
    @inputs.map { |elf| elf.sum }.sort.last(3).sum
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
