MODULO = 3 * 5 * 2 * 7 * 11 * 13 * 17 * 19

class Program
  def initialize
  end

  def simulate(rounds : Int32, worry_reduction : Proc)
    items: Array(Array(Int64)) = [
      [99, 67, 92, 61, 83, 64, 98],
      [78, 74, 88, 89, 50],
      [98, 91],
      [59, 72, 94, 91, 79, 88, 94, 51],
      [95, 72, 78],
      [76],
      [69, 60, 53, 89, 71, 88],
      [72, 54, 63, 80]
    ].map { |row| row.map { |i| i.to_i64 } }

    counts = Array.new(8) { 0_i64 }
    
    rounds.times do
      while !items[0].empty?
        item = items[0].shift
        item *= 17
        item = worry_reduction.call(item)
        if item % 3 == 0
          items[4] << item
        else
          items[2] << item
        end
        counts[0] += 1
      end
      
      while !items[1].empty?
        item = items[1].shift
        item *= 11
        item = worry_reduction.call(item)
        if item % 5 == 0
          items[3] << item
        else
          items[5] << item
        end
        counts[1] += 1
      end

      while !items[2].empty?
        item = items[2].shift
        item += 4
        item = worry_reduction.call(item)
        if item % 2 == 0
          items[6] << item
        else
          items[4] << item
        end
        counts[2] += 1
      end
      
      while !items[3].empty?
        item = items[3].shift
        item %= MODULO
        item *= item
        item = worry_reduction.call(item)
        if item % 13 == 0
          items[0] << item
        else
          items[5] << item
        end
        counts[3] += 1
      end
      
      while !items[4].empty?
        item = items[4].shift
        item += 7
        item = worry_reduction.call(item)
        if item % 11 == 0
          items[7] << item
        else
          items[6] << item
        end
        counts[4] += 1
      end
      
      while !items[5].empty?
        item = items[5].shift
        item += 8
        item = worry_reduction.call(item)
        if item % 17 == 0
          items[0] << item
        else
          items[2] << item
        end
        counts[5] += 1
      end
      
      while !items[6].empty?
        item = items[6].shift
        item += 5
        item = worry_reduction.call(item)
        if item % 19 == 0
          items[7] << item
        else
          items[1] << item
        end
        counts[6] += 1
      end
      
      while !items[7].empty?
        item = items[7].shift
        item += 3
        item = worry_reduction.call(item)
        if item % 7 == 0
          items[1] << item
        else
          items[3] << item
        end
        counts[7] += 1
      end
    end

    counts.sort.last(2).product
  end

  def part_2
  end

  def execute
    puts simulate(20, ->(i : Int64) { i // 3 } )
    puts simulate(10000, ->(i : Int64) { i % MODULO } )
  end
end

Program.new.execute
