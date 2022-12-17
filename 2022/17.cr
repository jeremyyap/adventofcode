require "../utils/coordinate"

class Program
  @inputs: String

  def initialize
    @inputs = File.read("17.txt").chomp
  end

  def simulate(total_rocks : Int64)
    rocks = [
      Set.new([{2,4}, {3,4}, {4,4}, {5,4}]),
      Set.new([{3,4}, {2,5}, {3,5}, {4,5}, {3,6}]),
      Set.new([{2,4}, {3,4}, {4,4}, {4,5}, {4,6}]),
      Set.new([{2,4}, {2,5}, {2,6}, {2,7}]),
      Set.new([{2,4}, {3,4}, {2,5}, {3,5}])
    ]
    r = j = height = 0
    heights = Array.new(7) { 0 }
    grid = Set(Coordinate).new
    (0...7).each { |x| grid.add({x, 0}) } # floor

    # cycle detection
    visited_states = Hash(Tuple(Int32, Int32, Array(Int32)), Tuple(Int32, Int64)).new

    num_rocks = num_cycles = cycle_height = cycle_length = 0_i64
    while num_rocks < total_rocks
      num_rocks += 1
      rock = rocks[r]
      rock = rock.map { |x, y| {x, y + height} }.to_set
      while true
        # sideways movement
        jet = @inputs[j]
        j = (j + 1) % @inputs.size
        if jet == '>' && rock.none? { |x, y| x == 6 }
          next_position = rock.map { |x, y| {x + 1, y} }.to_set
          rock = next_position unless next_position.intersects?(grid)
        elsif jet == '<' && rock.none? { |x, y| x == 0 }
          next_position = rock.map { |x, y| {x - 1, y} }.to_set
          rock = next_position unless next_position.intersects?(grid)
        end
        
        # downward movement
        next_position = rock.map { |x, y| {x, y - 1} }.to_set
        if next_position.intersects?(grid)
          rock.each { |x, y| heights[x] = [heights[x], y].max}
          height = heights.max
          grid.concat(rock)
          r = (r + 1) % rocks.size

          # cycle detection
          current_state = { j, r, heights.map { |h| height - h } }
          if visited_states.has_key?(current_state) && num_cycles == 0
            prev_height, prev_num_rocks = visited_states[current_state]
            cycle_height = height - prev_height
            cycle_length = num_rocks - prev_num_rocks

            num_cycles = (total_rocks - num_rocks) // cycle_length
            num_rocks += num_cycles * cycle_length
          elsif num_cycles == 0
            visited_states[current_state] = { height, num_rocks }
          end

          break
        else
          rock = next_position
        end
      end
    end

    num_cycles * cycle_height + height
  end

  def execute
    puts simulate(2022)          # part 1
    puts simulate(1000000000000) # part 2
  end
end

Program.new.execute
