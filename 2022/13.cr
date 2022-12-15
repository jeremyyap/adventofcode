class Packet
  include Comparable(Packet)
  getter contents : Array(Packet | Int32)

  @contents: Array(Packet | Int32)

  def initialize(@contents : Array(Packet | Int32)); end

  def <=>(other : Packet)
    @contents.zip?(other.contents).each do |a, b|
      if b == nil
        result = 1
      elsif a.is_a? Int32 && b.is_a? Int32
        result = a <=> b
      elsif a.is_a? Int32 && b.is_a? Packet
        result = Packet.new([a] of Int32 | Packet) <=> b
      elsif a.is_a? Packet && b.is_a? Int32
        result = a <=> Packet.new([b] of Int32 | Packet)
      elsif a.is_a? Packet && b.is_a? Packet
        result = a <=> b
      else
        result = 0
      end
      return result if result != 0
    end
    @contents.size <=> other.contents.size
  end

  def to_s(io : IO)
    io << '['
    io << @contents.join(',')
    io << ']'
  end
end

class Program
  @inputs: Array(Tuple(Packet, Packet))

  def initialize
    pairs = File.read("13.txt").chomp.split("\n\n")
    @inputs = pairs.map do |pair|
      first, second = pair.split("\n")
      { parse(first).as(Packet), parse(second).as(Packet) }
    end
  end

  def parse(str)
    return str.to_i if str =~ /^\d+$/
    return Packet.new([] of Int32 | Packet) if str.size == 2

    depth = 0
    comma_idx = -1
    contents = [] of Packet | Int32
    element_start = 1
    str.chars.each_with_index do |c, i|
      depth += 1 if c == '['
      depth -= 1 if c == ']'
      if c == ',' && depth == 1
        element_end = i - 1
        contents << parse(str[element_start..element_end])
        element_start = i + 1
      end
    end
    contents << parse(str[element_start...-1])

    Packet.new(contents)
  end

  def part_1
    sum = 0
    @inputs.each_with_index do |pair, index|
      first, second = pair
      sum += index + 1 if first <=> second <= 0
    end
    sum
  end

  def part_2
    packets = @inputs.flat_map { |first, second| [first, second] }
    packets << parse("[[2]]").as(Packet)
    packets << parse("[[6]]").as(Packet)
    packets.sort!
    packet_two_index = packets.index { |p| p.to_s == "[[2]]" }.not_nil! + 1
    packet_six_index = packets.index { |p| p.to_s == "[[6]]" }.not_nil! + 1
    packet_two_index * packet_six_index
  end

  def execute
    puts part_1
    puts part_2
  end
end                                                 

Program.new.execute
