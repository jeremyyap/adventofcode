class Program
  def initialize()
    @hash = Hash(String, Array(String)).new
    @count = 0

    inputs = File.read("6.txt").split
    inputs.each do |line|
      center, orbiter = line.split(')')
      @hash[center] = @hash.fetch(center, [] of String).push(orbiter)
    end
  end

  def dfs(node : String, depth : Int32)
    @count += depth
    @hash.fetch(node, [] of String).each { |child| dfs(child, depth + 1) }
  end

  def execute
    dfs("COM", 0)
    puts @count
  end
end

Program.new.execute
