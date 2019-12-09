class Program
  @instructions: Array(Int32)
  @parameter_modes: Array(Int8)
  @input: Channel(Int32)
  @output: Channel(Int32)

  def initialize(input : Channel(Int32), output : Channel(Int32))
    @instructions = File.read("7.txt").split(',').map(&.to_i)
    @parameter_modes = [] of Int8
    @pos = 0
    @input = input
    @output = output
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
          set_param(@input.receive)
        when 4
          @output.send(get_param)
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

def amplify(phase_settings : Array(Int32))
  channels = phase_settings.map { Channel(Int32).new }

  phase_settings.each_with_index do |phase, index|
    spawn do
      Program.new(channels[index], channels[(index + 1) % phase_settings.size]).execute
    end
    channels[index].send(phase)
  end

  channels.first.send(0)
  Fiber.yield
  channels.first.receive
end

inputs = [5, 6, 7, 8, 9]

max = 0
inputs.each_permutation do |permutation|
  max = [amplify(permutation), max].max
end
puts max
