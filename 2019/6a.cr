class Program
  def initialize()
    @hash = Hash(String, Array(String)).new { [] of String }
    @count = 0

    inputs = File.read("6.txt").split
    inputs.each do |line|
      center, orbiter = line.split(')')
      @hash[center] = @hash[center].push(orbiter)
    end
  end

  def dfs(node : String, depth : Int32)
    @count += depth
    @hash[node].each { |child| dfs(child, depth + 1) }
  end

  def execute
    dfs("COM", 0)
    puts @count
  end
end

Program.new.execute
