class Program
  @instructions: Array(Int32)
  @parameter_modes: Array(Int8)

  def initialize
    @instructions = File.read("5.txt").split(',').map(&.to_i)
    @parameter_modes = [] of Int8
    @pos = 0
  end

  def get_param
    parameter_mode = @parameter_modes.pop? || 0
    val = parameter_mode == 1 ? @instructions[@pos] : @instructions[@instructions[@pos]]
    @pos += 1
    val
  end

  def set_param(value)
    @parameter_modes.pop?
    @instructions[@instructions[@pos]] = value
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
          puts "Enter input:"
          set_param(gets.not_nil!.to_i)
        when 4
          puts get_param
        when 5
          @pos = get_param == 0 ? @pos + 1 : get_param
        when 6
          @pos = get_param == 0 ? get_param : @pos + 1
        when 7
          set_param(get_param < get_param ? 1 : 0)
        when 8
          set_param(get_param == get_param ? 1 : 0)
        when 99
          break
        else
          raise "Invalid opcode"
      end
    end
  end
end

Program.new.execute
