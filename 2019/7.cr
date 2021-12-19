require "./intcode"

class Program
  @instructions: Array(Int64)

  def initialize
    @instructions = File.read("7.txt").chomp.split(',').map(&.to_i64)
  end

  def amplify(phase_settings : Array(Int32), channels : Array(Channel(Int64)))
    phase_settings.each_with_index do |phase, i|
      spawn { Intcode.new(@instructions, channels[i], channels[i+1]).execute }
      channels[i].send(phase.to_i64)
    end
    channels.first.send(0_i64)
    Fiber.yield
    channels.last.receive
  end

  def execute
    # part 1
    channels = Array.new(6) { Channel(Int64).new }
    puts [0,1,2,3,4].permutations.max_of { |permutation| amplify(permutation, channels) }

    # part 2
    channels[5] = channels.first
    puts [5,6,7,8,9].permutations.max_of { |permutation| amplify(permutation, channels) }
  end
end

Program.new.execute
