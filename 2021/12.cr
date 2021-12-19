class Program
  @inputs: Hash(String, Array(String))

  def initialize
    @inputs = Hash(String, Array(String)).new { [] of String }
    File.read("12.txt").chomp.split("\n").map do |line|
      parts = line.split("-")
      @inputs[parts[0]] <<= parts[1]
      @inputs[parts[1]] <<= parts[0]
    end
  end

  def is_uppercase?(str : String)
    str == str.upcase
  end

  def dfs(partial : Array(String), can_revisit? : Bool)
    return [partial] if partial[-1] == "end"

    routes = [] of Array(String)
    @inputs[partial[-1]].each do |next_cave|
      if is_uppercase?(next_cave) || !partial.includes?(next_cave)
        routes += dfs(partial + [next_cave], can_revisit?)
      elsif next_cave != "start" && can_revisit?
        routes += dfs(partial + [next_cave], false)
      end
    end
    routes
  end

  def execute
    puts dfs(["start"], false).size # part 1
    puts dfs(["start"], true).size # part 2
  end
end

Program.new.execute
