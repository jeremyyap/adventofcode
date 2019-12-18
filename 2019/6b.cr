class Program
  def initialize()
    @hash = Hash(String, Array(String)).new { [] of String }
    @visited = Set(String).new

    inputs = File.read("6.txt").split
    inputs.each do |line|
      center, orbiter = line.split(')')
      @hash[center] = @hash[center].push(orbiter)
      @hash[orbiter] = @hash[orbiter].push(center)
    end
  end

  def visited?(node : String)
    @visited.includes?(node)
  end

  def visit(node : String)
    @visited.add(node)
  end

  def bfs(node : String, depth : Int32)
    @hash[node].each { |child| dfs(child, depth + 1) }
  end

  def execute
    distance = -2
    queue = ["YOU"]

    while !queue.empty?
      queue.size.times do
        current = queue.shift
        unless visited?(current)
          return distance if current == "SAN"
          queue += @hash[current]
          visit(current)
        end
      end
      distance += 1
    end

    distance
  end
end

puts Program.new.execute
