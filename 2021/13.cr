class Program
  @dots: Array(Tuple(Int32, Int32))
  @folds: Array(Tuple(String, Int32))

  def initialize
    input = File.read("13.txt").strip.split("\n\n")
    @dots = input[0].split("\n").map { |row| { row.split(",")[0].to_i, row.split(",")[1].to_i } }
    @folds = input[1].split("\n").map do |line|
      fold = line[11..-1]
      axis, value = fold.split("=")
      { axis, value.to_i }
    end
  end

  def reflect(value : Int32, line : Int32)
    value > line ? 2 * line - value : value
  end

  def execute
    dots_set = @dots.to_set

    @folds.each_with_index do |fold, i|
      if fold[0] == "x"
        dots_set = dots_set.map { |dot| { reflect(dot[0], fold[1]), dot[1] } }.to_set
      else
        dots_set = dots_set.map { |dot| { dot[0], reflect(dot[1], fold[1]) } }.to_set
      end

      # part 1
      puts dots_set.size if i == 0
    end

    x_max = dots_set.max_of { |d| d[0] }
    y_max = dots_set.max_of { |d| d[1] }

    # part 2
    (0..y_max).each do |y|
      (0..x_max).each do |x|
        print dots_set.includes?({x,y}) ? '*' : ' '
      end
      puts
    end
  end
end

Program.new.execute
