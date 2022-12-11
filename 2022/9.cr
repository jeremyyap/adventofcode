class Program
  @inputs: Array(Tuple(Char, Int32))

  def initialize
    @inputs = File.read("9.txt").chomp.split("\n").map do |row|
      { row[0], row[2..-1].to_i}
    end
  end

  def process(length : Int32)
    knots = Array.new(length) { { 0, 0} }
    visited = Set.new([{ 0, 0 }])
    @inputs.each do |(dir, amt)|
      amt.times do
        if dir == 'U'
          knots[0] = { knots[0][0], knots[0][1] + 1 }
        elsif dir == 'D'
          knots[0] = { knots[0][0], knots[0][1] - 1 }
        elsif dir == 'L'
          knots[0] = { knots[0][0] - 1, knots[0][1] }
        else
          knots[0] = { knots[0][0] + 1, knots[0][1] }
        end
        
        (0...(length-1)).each do |i|
          d0, d1 = 0, 0
          if (knots[i+1][0] == knots[i][0] && (knots[i+1][1] - knots[i][1]).abs > 1)
            d0 = 0
            d1 = knots[i+1][1] > knots[i][1] ? -1 : 1
          elsif (knots[i+1][1] == knots[i][1] && (knots[i+1][0] - knots[i][0]).abs > 1)
            d0 = knots[i+1][0] > knots[i][0] ? -1 : 1
            d1 = 0
          elsif ((knots[i+1][1] - knots[i][1]).abs > 1 || (knots[i+1][0] - knots[i][0]).abs > 1)
            d0 = knots[i+1][0] > knots[i][0] ? -1 : 1
            d1 = knots[i+1][1] > knots[i][1] ? -1 : 1
          end
          knots[i+1] = { knots[i+1][0] + d0, knots[i+1][1] + d1 }
        end

        visited.add(knots[-1])
      end
    end
    visited.size
  end

  def execute
    puts process(2)  # part 1
    puts process(10) # part 2
  end
end

Program.new.execute
