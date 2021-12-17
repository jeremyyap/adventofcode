class Heap(T)
  @heap: Array(T)
  @size: Int32
  @comparator: (T, T -> Bool)

  enum HeapType : UInt8
    MinHeap
    MaxHeap
  end

  def initialize(&proc : (T, T -> Bool))
    @heap = [] of T
    @size = 0
    @comparator = proc
  end

  def initialize
    # default comparator is min heap
    initialize(Proc(T, T, Bool).new { |a, b| a < b })
  end

  def empty?
    @size == 0
  end

  def peek
    @heap[0]
  end

  def pop
    result = peek

    if @size > 1
      @size -= 1
      @heap[0] = @heap[@size]
      rebalance_down(0)
    else
      @size = 0
    end

    @heap.delete_at(@size)
    result
  end

  def add(element)
    @heap << element
    @size += 1
    rebalance_up(@size - 1)
    self
  end

  def <<(element)
    add(element)
  end

  def compare(a, b)
    @comparator.call(a, b)
  end

  def has_parent(i); i >= 1;           end
  def parent(i);     (i - 1) // 2;     end
  def has_left(i);   left(i) < @size;  end
  def left(i);       i * 2 + 1;        end
  def has_right(i);  right(i) < @size; end
  def right(i);      i * 2 + 2;        end

  def rebalance_up(i)
    parent_i = parent(i)

    if has_parent(i) && compare(@heap[i], @heap[parent_i])
      @heap[i], @heap[parent_i] = @heap[parent_i], @heap[i]
      rebalance_up(parent_i)
    end
  end

  def rebalance_down(i)
    left_i = left(i)
    right_i = right(i)
    if has_left(i) && compare(@heap[left_i], @heap[i]) && (!has_right(i) || compare(@heap[left_i], @heap[right_i]))
      @heap[i], @heap[left_i] = @heap[left_i], @heap[i]
      rebalance_down(left_i)
    elsif has_right(i) && compare(@heap[right_i], @heap[i])
      @heap[i], @heap[right_i] = @heap[right_i], @heap[i]
      rebalance_down(right_i)
    end
  end
end
