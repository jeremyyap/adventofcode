class Program
  @inputs: Array(Tuple(String, String))
  @outputs: Hash(String, Channel(Int64))

  def initialize
    @inputs = File.read("21.txt").chomp.split("\n").map do |row|
      monkey, job = row.split(": ")
      { monkey, job}
    end
    @outputs = Hash(String, Channel(Int64)).new
    @inputs.each { |monkey, job| @outputs[monkey] = Channel(Int64).new }
  end

  def perform(monkey : String, job : String)
    if job.includes? '-'
      a, b = job.split(" - ")
      result = @outputs[a].receive - @outputs[b].receive
    elsif job.includes? '+'
      a, b = job.split(" + ")
      result = @outputs[a].receive + @outputs[b].receive
    elsif job.includes? '*'
      a, b = job.split(" * ")
      result = @outputs[a].receive * @outputs[b].receive
    elsif job.includes? '/'
      a, b = job.split(" / ")
      result = @outputs[a].receive // @outputs[b].receive
    else
      result = job.to_i64
    end
    @outputs[monkey].send(result)
  end

  def part_1
    @inputs.each do |monkey, job|
      spawn { perform(monkey, job ) }
    end
    @outputs["root"].receive
  end

  def part_2
    (0_i64..part_1).bsearch do |i|
      @inputs.each do |monkey, job|
        if monkey == "root"
          spawn do
            a, b = job.split(" + ")
            @outputs[monkey].send(@outputs[a].receive - @outputs[b].receive)
          end
        elsif monkey == "humn"
          spawn { @outputs[monkey].send(i) }
        else
          spawn { perform(monkey, job ) }
        end
      end

      @outputs["root"].receive <= 0_i64
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
