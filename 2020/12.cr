class Program
  @input: Array(String)

  def initialize
    @input = File.read("12.txt")[0..-2].split
  end

  # 0 = N, 1 = E, 2 = S, 3 = W

  def part_1
    x = 0
    y = 0
    dir = 1

    @input.each do |line|
      action = line[0]
      value = line[1..-1].to_i

      case action
      when 'N'
        y += value
      when 'S'
        y -= value
      when 'E'
        x += value
      when 'W'
        x -= value
      when 'L'
        dir = (dir + 3 * (value // 90)) % 4
      when 'R'
        dir = (dir + 1 * (value // 90)) % 4
      when 'F'
        case dir
        when 0
          y += value
        when 1
          x += value
        when 2
          y -= value
        when 3
          x -= value
        end
      end
    end
    x.abs + y.abs
  end

  def part_2
    wx = 10
    wy = 1
    x = 0
    y = 0
    dir = 1

    @input.each do |line|
      action = line[0]
      value = line[1..-1].to_i

      case action
      when 'N'
        wy += value
      when 'S'
        wy -= value
      when 'E'
        wx += value
      when 'W'
        wx -= value
      when 'L'
        (value // 90).times do
          wx, wy = -wy, wx
        end
      when 'R'
        (value // 90).times do
          wx, wy = wy, -wx
        end
      when 'F'
        x += wx * value
        y += wy * value
      end
    end
    x.abs + y.abs
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
