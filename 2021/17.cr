class Program
  @target_x: Range(Int32, Int32)
  @target_y: Range(Int32, Int32)

  def initialize
    @target_x = 211..232
    @target_y = -124..-69
  end

  def fire(vx : Int32, vy : Int32)
    x, y, max_y, hit = 0, 0, 0, false

    while x <= @target_x.max && (vx != 0 || @target_x.includes?(x)) && y >= @target_y.min
      x += vx
      y += vy
      vx += 1 if vx < 0
      vx -= 1 if vx > 0
      vy -= 1
      max_y = [max_y, y].max
      break hit = true if @target_x.includes?(x) && @target_y.includes?(y)
    end

    return hit, max_y
  end

  def execute
    max_y, count = 0, 0
    (1..@target_x.max).each do |vx|
      (@target_y.min..(-@target_y.min)).each do |vy|
        hit, result = fire(vx,vy)
        max_y = [result, max_y].max if hit
        count += 1 if hit
      end
    end

    puts max_y # part 1
    puts count # part 2
  end
end

Program.new.execute
