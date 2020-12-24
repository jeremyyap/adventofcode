class ListNode
  property value : Int32

  def initialize(value)
    @value = value
    @next = self
  end

  def next
    @next
  end

  def next=(node : ListNode)
    @next = node
  end
end

class Program
  @input : Array(Int32)

  def initialize
    @input = File.read("23.txt")[0..-2].chars.map(&.to_i)
  end

  def part_1
    cups = @input.clone

    100.times do
      current_cup = cups.shift
      three_cups = cups[0..2]
      cups = cups[3..-1]
      smaller_cups = cups.select { |cup| cup < current_cup }
      destination_cup = smaller_cups.size == 0 ? cups.max : smaller_cups.max
      destination_cup_index = cups.index(destination_cup)
      raise "error" unless destination_cup_index
      cups = cups[0..destination_cup_index] + three_cups + cups[(destination_cup_index+1)..-1] + [current_cup]
      puts cups.map(&.to_s).join
    end
    cups.map(&.to_s).join
  end

  def part_2(num_cups, times)
    hash = Hash(Int32, ListNode).new

    dummy = ListNode.new(0)
    head = dummy
    (1..num_cups).each do |i|
      node = ListNode.new(i)
      hash[i] = node
      head.next = node
      head = node
    end
    head.next = dummy.next
    head = dummy.next

    node = head
    @input.each do |i|
      node.value = i if node
      hash[i] = node
      node = node.next if node
    end

    current_cup = head
    times.times do
      first_cup = current_cup.next
      second_cup = first_cup.next
      third_cup = second_cup.next
      next_cup = third_cup.next

      destination_value = (current_cup.value - 1)
      while [first_cup.value, second_cup.value, third_cup.value, 0].includes?(destination_value)
        destination_value -= 1
        destination_value = hash.keys.max if destination_value < 0
      end
      destination_cup = hash[destination_value]

      current_cup.next = next_cup
      third_cup.next = destination_cup.next
      destination_cup.next = first_cup
      destination_cup.next

      current_cup = next_cup
    end

    cup_one = hash[1]
  end

  def execute
    # Part 1
    cup = part_2(@input.size, 100)
    result = ""
    (@input.size - 1).times do
      cup = cup.next
      result += cup.value.to_s
    end
    puts result

    # Part 2
    cup_one = part_2(1000000, 10000000)
    puts cup_one.next.value.to_i64 * cup_one.next.next.value
  end
end

Program.new.execute
