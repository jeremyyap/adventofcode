class Program
  @instructions: Array(Int64)
  @parameter_modes: Array(Int8)
  @pos: Int64
  @input: Channel(Int64)
  @output: Channel(Int64)
  @relative_base: Int64

  def initialize(input : Channel(Int64), output : Channel(Int64))
    @instructions = File.read("9.txt").split(',').map(&.to_i64)
    @parameter_modes = [] of Int8
    @pos = 0
    @input = input
    @output = output
    @relative_base = 0
  end

  def parameter_index
    parameter_mode = @parameter_modes.pop? || 0
    index = case parameter_mode
    when 0
      @instructions[@pos]
    when 1
      @pos
    when 2
      @relative_base + @instructions[@pos]
    else
      raise "Invalid parameter mode"
    end

    if index >= @instructions.size
      @instructions += Array(Int64).new(index - @instructions.size + 1, 0)
    end

    index
  end

  def get_param
    val = @instructions[parameter_index]
    @pos += 1
    val
  end

  def set_param(value : Int64)
    index = parameter_index
    @instructions[index] = value
    @pos += 1
  end

  def execute
    while true
      instruction = @instructions[@pos]
      @parameter_modes = (instruction // 100).to_s.split("").map(&.to_i8)
      @pos += 1
      opcode = instruction % 100

      case opcode
        when 1
          set_param(get_param + get_param)
        when 2
          set_param(get_param * get_param)
        when 3
          set_param(@input.receive)
        when 4
          @output.send(get_param)
        when 5
          @pos = get_param == 0 ? @pos + 1 : get_param
        when 6
          @pos = get_param == 0 ? get_param : @pos + 1
        when 7
          set_param(get_param < get_param ? 1.to_i64 : 0.to_i64)
        when 8
          set_param(get_param == get_param ? 1.to_i64 : 0.to_i64)
        when 9
          @relative_base += get_param
        when 99
          break
        else
          raise "Invalid opcode"
      end
    end
  end
end

input = Channel(Int64).new
output = Channel(Int64).new

spawn do
  Program.new(input, output).execute
end

input.send(2)
Fiber.yield
puts output.receive
