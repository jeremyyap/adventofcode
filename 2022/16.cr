require "../utils/coordinate"

class Program
  @raw_graph : Hash(String, Array(String))
  @graph : Hash(Int32, Hash(Int32, Int32))
  @flow_rates : Hash(String, Int32)
  @memo : Hash(Tuple(Int32, Int32, Int32), Int32)

  def initialize
    @graph = Hash(Int32, Hash(Int32, Int32)).new { Hash(Int32, Int32).new }
    @flow_rates = Hash(String, Int32).new { 0 }
    @raw_graph = Hash(String, Array(String)).new { Array(String).new }
    @memo = Hash(Tuple(Int32, Int32, Int32), Int32).new
    
    rows = File.read("16.txt").chomp.split("\n")
    rows.map do |row|
      valve, flow_rate, tunnels = row.match(/^Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z, ]+)$/)
      .try(&.captures).not_nil!.map(&.not_nil!)
      @flow_rates[valve] = flow_rate.to_i if flow_rate != "0"
      @raw_graph[valve] = tunnels.split(", ")
    end

    bfs("AA")
    @flow_rates.keys.each { |valve| bfs(valve) }
  end

  def valve_to_index(valve : String)
    return @flow_rates.keys.size if valve == "AA"
    @flow_rates.keys.index(valve).not_nil!
  end

  def bfs(start : String)
    queue = [] of {String, Int32}
    visited = Set(String).new
    queue.push({start, 0})

    while !queue.empty?
      valve, distance = queue.shift
      next if visited.includes?(valve)
      visited.add(valve)

      if @flow_rates[valve] != 0
        edges = @graph[valve_to_index(start)]
        edges[valve_to_index(valve)] = distance + 1 # cost to travel to valve from start and open it
        @graph[valve_to_index(start)] = edges
      end
      @raw_graph[valve].each do |dest|
        queue << { dest, distance + 1 }
      end
    end
  end

  def max_pressure_released(current_valve : Int32, visited : Int32, time_remaining : Int32): Int32
    return @memo[{current_valve, visited, time_remaining}] if @memo.has_key?({current_valve, visited, time_remaining})
    pressure_released = current_valve == @flow_rates.keys.size ?
      0 : time_remaining * @flow_rates.values[current_valve]
    return 0 if time_remaining < 0
    visited ^= (1 << current_valve)

    max = 0
    (0...@flow_rates.keys.size).each do |valve|
      if visited & (1 << valve) == 0
        max = [max, max_pressure_released(valve, visited, time_remaining - @graph[current_valve][valve])].max
      end
    end
    visited ^= (1 << current_valve)
    return @memo[{current_valve, visited, time_remaining}] = pressure_released + max
  end

  def part_1
    max_pressure_released(@flow_rates.keys.size, 0, 30)
  end

  def part_2
    max = 0
    size = @flow_rates.keys.size
    (0...2**(@flow_rates.keys.size-1)).each do |n|
      m = 2**@flow_rates.keys.size - 1 - n
      max = [max, max_pressure_released(@flow_rates.keys.size, m, 26) + max_pressure_released(@flow_rates.keys.size, n, 26)].max
    end
    max
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
