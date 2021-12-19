class Program
  @inputs: Array(String)

  def initialize
    @inputs = File.read("8.txt").chomp.split("\n")
  end

  def part_1
    @inputs.sum do |line|
      outputs = line.split(" | ")[1].split(" ")
      outputs.count { |o| [2,3,4,7].includes?(o.size) }
    end
  end

  def part_2
    @inputs.sum do |line|
      digits_part, outputs_part = line.split(" | ")
      digits = digits_part.split(" ")
      outputs = outputs_part.split(" ")

      segment_digit_map = {
        "abcefg" => '0',
        "cf" => '1',
        "acdeg" => '2',
        "acdfg" => '3',
        "bcdf" => '4',
        "abdfg" => '5',
        "abdefg" => '6',
        "acf" => '7',
        "abcdefg" => '8',
        "abcdfg" => '9'
      }

      expected_frequency_map = "abcdefg".chars.map do |segment|
        { segment, segment_digit_map.keys.count { |segments| segments.includes?(segment) } }
      end.to_h

      frequencies_digit_map = segment_digit_map.map do |segments, digit|
        [segments.chars.map { |c| expected_frequency_map[c] }.sort.join, digit]
      end.to_h

      jumbled_frequency_map = "abcdefg".chars.map do |segment|
        { segment, digits.count { |digit| digit.includes?(segment) } }
      end.to_h

      outputs.map do |output|
        frequencies = output.chars.map { |c| jumbled_frequency_map[c] }.sort.join
        frequencies_digit_map[frequencies]
      end.join.to_i
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
