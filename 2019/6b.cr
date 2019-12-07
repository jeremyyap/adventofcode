class Program
  def initialize()
    @hash = Hash(String, Array(String)).new
    @visited = Hash(String, Bool).new

    inputs = File.read("6.txt").split
    inputs.each do |line|
      center, orbiter = line.split(')')
      @hash[center] = @hash.fetch(center, [] of String).push(orbiter)
      @hash[orbiter] = @hash.fetch(orbiter, [] of String).push(center)
    end
  end

  def visited?(node : String)
    @visited.fetch(node, false)
  end

  def bfs(node : String, depth : Int32)
    @hash.fetch(node, [] of String).each { |child| dfs(child, depth + 1) }
  end

  def execute
    distance = -2
    queue = ["YOU"]

    while !queue.empty?
      queue.size.times do
        current = queue.shift
        unless visited?(current)
          return distance if current == "SAN"
          queue += @hash.fetch(current, [] of String)
          @visited[current] = true
        end
      end
      distance += 1
    end

    distance
  end
end

puts Program.new.execute
