class Intcode
  @instructions: Array(Int64)
  @parameter_modes: Array(Int8)
  @pos: Int64
  @blocking: Bool
  @input: Channel(Int64) | Nil
  @output: Channel(Int64) | Nil
  @relative_base: Int64

  def initialize(instructions : Array(Int64),
                 input : Channel(Int64) | Nil = nil,
                 output : Channel(Int64) | Nil = nil,
                 blocking : Bool = true)
    @instructions = instructions
    @parameter_modes = [] of Int8
    @pos = 0
    @blocking = blocking
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
    index = parameter_index
    val = @instructions[index]
    @pos += 1
    val
  end

  def set_param(value : Int64)
    index = parameter_index
    @instructions[index] = value
    @pos += 1
  end

  def receive_input
    return -1_i64 if @input == nil
    return @input.not_nil!.receive if @blocking
    select
    when input = @input.not_nil!.receive
      input
    else
      -1_i64
    end
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
        set_param(receive_input)
      when 4
        @output.not_nil!.send(get_param) if @output
      when 5
        @pos = get_param == 0 ? @pos + 1 : get_param
      when 6
        @pos = get_param == 0 ? get_param : @pos + 1
      when 7
        set_param(get_param < get_param ? 1_i64 : 0_i64)
      when 8
        set_param(get_param == get_param ? 1_i64 : 0_i64)
      when 9
        @relative_base += get_param
      when 99
        break
      else
        raise "Invalid opcode"
      end
      Fiber.yield unless @blocking
    end
  end
end
