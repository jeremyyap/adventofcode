class Program
  @inputs: Array(String)

  def initialize
    @inputs = File.read("7.txt").chomp.split("\n")
  end

  def process()
    dirs = Hash(String, Int64).new(0)
    stack = [""]
    visited = Hash(String, Int32).new(0)

    @inputs.each do |row|
      parts = row.split(' ')
      if parts[0] == "$"
        if parts[1] == "cd"
          if parts[2] == "/"
            stack = [""]
          elsif parts[2] == ".."
            stack.pop if stack.size > 1
          else
            stack << stack.last + '/' + parts.last
          end
        else
          visited[stack[-1]] += 1
        end
      elsif visited[stack[-1]] == 1
        stack.each { |dir| dirs[dir] += parts[0].to_i } if parts[0] != "dir"
      end
    end
    # dirs.values.select { |v| v <= 100000 }.sum
    min_delete = dirs[""] - ( 70000000 - 30000000)
    dirs.values.sort.find { |v| v >= min_delete }
  end

  def execute
    puts process()  # part 1
    # puts process() # part 2
  end
end

Program.new.execute
