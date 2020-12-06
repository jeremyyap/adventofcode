class Program
  @inputs: Array(String)

  def initialize
    @inputs = File.read("6.txt")[0..-2].split("\n\n")
  end

  def part_1
    @inputs.sum do |group|
      set = Set(Char).new
      group.each_char do |char|
        set.add(char) if char != '\n'
      end
      set.size
    end
  end

  def part_2
    @inputs.sum do |group|
      hash = Hash(Char, Int32).new(0)
      group.each_char do |char|
        hash[char] = hash[char] + 1
      end

      group_size = hash['\n'] + 1
      hash.values.count { |value| value == group_size }
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
