class Program
  @input: Array(Int32)

  def initialize
    @input = File.read("16.txt").chomp.chars.flat_map { |c| c.to_i(16).to_s(2).rjust(4, '0').chars.map(&.to_i) }
  end

  def parse_literal(start : Int32)
    binary_str = ""
    pointer = start+6

    loop do
      is_last_group = @input[pointer] == 0
      binary_str += @input[(pointer+1)..(pointer+4)].join
      pointer += 5
      return binary_str.to_i64(2), pointer if is_last_group
    end
  end

  def operate(arr : Array(Int64), packet_type : Int32)
    case packet_type
    when 0; arr.sum
    when 1; arr.product
    when 2; arr.min
    when 3; arr.max
    when 5; arr[0] > arr[1] ? 1_i64 : 0_i64
    when 6; arr[0] < arr[1] ? 1_i64 : 0_i64
    else; arr[0] == arr[1] ? 1_i64 : 0_i64
    end
  end

  def parse(start : Int32)
    packet_version = @input[start..(start+2)].join.to_i(2)
    packet_type = @input[(start+3)..(start+5)].join.to_i(2)

    return packet_version, *parse_literal(start) if packet_type == 4

    pointer = start
    version_sum = packet_version
    sub_packet_values = [] of Int64

    proc = -> { # parse subpackets
      version, value, pointer = parse(pointer)
      sub_packet_values << value
      version_sum += version
    }

    if @input[start+6] == 0 # length type bit
      sub_packets_length = @input[(start+7)..(start+21)].join.to_i(2)
      pointer = start + 22
      while pointer < sub_packets_length + start + 22
        proc.call
      end
    else
      sub_packets_count = @input[(start+7)..(start+17)].join.to_i(2)
      pointer = start + 18
      sub_packets_count.times(&proc)
    end
    return version_sum, operate(sub_packet_values, packet_type), pointer
  end

  def execute
    version_sum, value, _ = parse(0)
    puts version_sum # part 1
    puts value # part 2
  end
end

Program.new.execute
