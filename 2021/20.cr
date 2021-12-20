require "../utils/coordinate"

class Program
  @algorithm: Array(Char)
  @image: Hash(Coordinate, Char)

  def initialize
    first_line, rest = File.read("20.txt").chomp.split("\n\n")
    @algorithm = first_line.chars
    @image = Hash(Coordinate, Char).new('.')
    rest.split("\n").each_with_index do |row, y|
      row.chars.each_with_index do |c, x|
        @image[{y,x}] = '#' if c == '#'
      end
    end
  end

  def blah(image : Hash(Coordinate, Char), y : Int32, x : Int32)
    ((y-1)..(y+1)).flat_map do |i|
      ((x-1)..(x+1)).flat_map do |j|
        image[{i,j}] == '#' ? '1' : '0'
      end
    end.join.to_i(2)
  end

  def enhance(image : Hash(Coordinate, Char), default : Char)
    enhanced_image = Hash(Coordinate, Char).new(default)
    min_x, max_x = image.keys.minmax_of { |y,x| x }
    min_y, max_y = image.keys.minmax_of { |y,x| y }
    ((min_x-1)..(max_x+1)).each do |x|
      ((min_y-1)..(max_y+1)).each do |y|
        char = @algorithm[blah(image, y, x)]
        enhanced_image[{y,x}] = char if char != default
      end
    end
    enhanced_image
  end

  def enhance_n(n : Int32)
    default = '.'
    result = @image
    n.times do
      default = default == '#' ? @algorithm[-1] : @algorithm[0]
      result = enhance(result, default)
    end
    # print_image(result, default)
    result.keys.size
  end

  def execute
    puts enhance_n(2)  # part 1
    puts enhance_n(50) # part 2
  end
end

Program.new.execute
