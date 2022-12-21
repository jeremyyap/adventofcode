class ListNode
  getter value : Int64
  setter value : Int64
  setter next_node : ListNode
  setter prev_node : ListNode

  @value: Int64
  @prev_node: ListNode | Nil
  @next_node: ListNode | Nil

  def prev_node()
    @prev_node.not_nil!
  end

  def next_node()
    @next_node.not_nil!
  end

  def initialize(@value : Int64); end
end

class Program
  @inputs: Array(ListNode)

  def initialize
    @inputs = File.read("20.txt")
      .chomp
      .split("\n")
      .map(&.to_i64)
      .map { |value| ListNode.new(value) }
  end

  def build_linked_list
    @inputs.each_cons(2) { |(a, b)| a.next_node = b; b.prev_node = a }
    @inputs[-1].next_node = @inputs[0]
    @inputs[0].prev_node = @inputs[-1]
  end

  def mix
    @inputs.each do |current|
      shift = current.value % (@inputs.size - 1)
      next if shift == 0
      current.prev_node.next_node, current.next_node.prev_node = current.next_node, current.prev_node

      node = current
      if shift > 0
        shift.times { node = node.next_node }
        successor = node.next_node
        node.next_node = successor.prev_node = current
        current.prev_node, current.next_node = node, successor
      else
        (-shift).times { node = node.prev_node }
        predecessor = node.prev_node
        node.prev_node = predecessor.next_node = current
        current.prev_node, current.next_node = predecessor, node
      end
    end
  end

  def part_1
    build_linked_list
    mix

    node = @inputs.find { |node| node.value == 0 }.not_nil!
    sum = 0
    3.times do
      1000.times { node = node.next_node }
      sum += node.value
    end
    sum
  end

  def part_2
    build_linked_list
    @inputs.each { |input| input.value = input.value * 811589153 }
    10.times { mix }

    node = @inputs.find { |node| node.value == 0 }.not_nil!
    sum = 0_i64
    3.times do
      1000.times { node = node.next_node }
      sum += node.value
    end
    sum
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
