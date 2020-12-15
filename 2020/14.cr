require "big"

class Program
  @input: Array(String)

  def initialize
    @input = File.read("14.txt")[0..-2].split('\n')
  end

  def set_bit(val, bit_idx)
    val | (1_i64 << bit_idx)
  end

  def clear_bit(val, bit_idx)
    val & ~(1_i64 << bit_idx)
  end

  def parse_addr(mem_str)
    mem_str[4..-2].to_i64
  end

  def part_1
    mask_0 = 0
    mask_1 = 1
    memory = Hash(Int64, Int64).new

    @input.each do |line|
      cmd, val = line.split(" = ")
      if cmd == "mask"
        mask_0 = val.gsub('X', '1').to_i64(2)
        mask_1 = val.gsub('X', '0').to_i64(2)
      else
        addr = parse_addr(cmd)
        memory[addr] = (val.to_i64 & mask_0) | mask_1
      end
    end

    memory.values.sum
  end

  def addresses(addr, mask, idx)
    return [addr] if idx == mask.size

    return addresses(set_bit(addr, 35-idx), mask, idx+1) + addresses(clear_bit(addr, 35-idx), mask, idx+1) if mask[idx] == 'X'
    return addresses(set_bit(addr, 35-idx), mask, idx+1) if mask[idx] == '1'
    return addresses(addr, mask, idx+1)
  end

  def part_2
    mask = ""
    memory = Hash(Int64, Int64).new
    @input.each do |line|
      cmd, val = line.split(" = ")
      if cmd == "mask"
        mask = val
      else
        base_addr = parse_addr(cmd)
        addresses(base_addr, mask, 0).each { |addr| memory[addr] = val.to_i64 }
      end
    end

    memory.values.sum
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
