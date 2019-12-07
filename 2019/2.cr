class Program
  @instructions: Array(Int32)
  @pos: Int32

  def initialize(noun : Int32, verb : Int32)
    @instructions = File.read("2.txt").split(',').map(&.to_i)
    @instructions[1] = noun
    @instructions[2] = verb
    @pos = 0
  end

  def get_param
    val = @instructions[@instructions[@pos]]
    @pos += 1
    val
  end

  def set_param(value)
    @instructions[@instructions[@pos]] = value
    @pos += 1
  end

  def execute
    while true
      instruction = @instructions[@pos]
      @pos += 1

      case instruction
        when 1
          set_param(get_param + get_param)
        when 2
          set_param(get_param * get_param)
        when 99
          return @instructions[0]
        else
          raise "Invalid opcode"
      end
    end
  end
end

(1..99).each do |i|
  (1..99).each do |j|
    if Program.new(i, j).execute == 19690720
      puts 100 * i + j
    end
  end
end
