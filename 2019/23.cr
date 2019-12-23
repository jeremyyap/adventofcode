require "./intcode"

def boot(inputs : Array(Channel(Int64)), outputs : Array(Channel(Int64)))
  (0..49).each do |i|
    spawn do
      instructions = File.read("23.txt").split(',').map(&.to_i64)
      inputs[i].send(i.to_i64)
      Intcode.new(instructions, inputs[i], outputs[i], false).execute
    end
  end
end

def route_packets(inputs : Array(Channel(Int64)),
                  outputs : Array(Channel(Int64)),
                  nat_input : Channel(Int64))
  while true
    outputs.each do |output|
      select
      when address = output.receive
        x = output.receive
        y = output.receive

        if address == 255
          nat_input.send(x)
          nat_input.send(y)
        else
          inputs[address].send(x)
          inputs[address].send(y)
        end
      else
      end
    end
    Fiber.yield
  end
end

inputs = Array.new(50) { Channel(Int64).new(32) }
outputs = Array.new(50) { Channel(Int64).new(32) }
nat_input = Channel(Int64).new(32)

boot(inputs, outputs)
spawn route_packets(inputs, outputs, nat_input)

x = y = last_x = last_y = 0_i64
done = false
spawn do
  until done
    x = nat_input.receive
    y = nat_input.receive
  end
end

until done
  sleep 1
  puts "Sending #{x}, #{y}"
  inputs[0].send(x)
  inputs[0].send(y)
  if last_y == y
    puts y
    done = true
  end
  last_x, last_y = x, y
end
