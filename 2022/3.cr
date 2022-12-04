class Program
  @inputs: Array(String)

  def initialize
    @inputs = File.read("3.txt").chomp.split("\n")
  end

  def part_1
    @inputs.sum do |row|
      char = row.chars
        .each_slice(row.size // 2)
        .map(&.to_set)
        .reduce { |acc, set| acc & set }.first

      if (char.lowercase?)
        char.ord - 'a'.ord + 1
      else
        char.ord - 'A'.ord + 27
      end
    end
  end

  def part_2
    @inputs.each_slice(3).sum do |(elf1, elf2, elf3)|
      char = (elf1.chars.to_set & elf2.chars.to_set & elf3.chars.to_set).first

      if (char.lowercase?)
        char.ord - 'a'.ord + 1
      else
        char.ord - 'A'.ord + 27
      end
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
