class Program
  @input: Array(Array(Char))

  def initialize
    @input = File.read("11.txt").chomp.split.map(&.chars)
  end

  def fill_seats
    old_state = @input.map { |row| row.clone }
    while true
      # print(old_state)
      new_state = old_state.map { |row| row.clone }
      old_state.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          new_state[i][j] = yield old_state, i, j
        end
      end

      done = true
      old_state.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          done = false if old_state[i][j] != new_state[i][j]
        end
      end

      return old_state.sum { |row| row.count('#') } if done
      old_state = new_state
    end
  end

  def part_1
    fill_seats do |state, r, c|
      count = 0
      [r-1,r,r+1].each do |rr|
        [c-1,c,c+1].each do |cc|
          next if rr == r && cc == c
          count += 1 if rr >= 0 && cc >= 0 && state[rr]? && state[rr][cc]? == '#'
        end
      end

      seat = state[r][c]
      seat = '#' if count == 0 && seat == 'L'
      seat = 'L' if count >= 4 && seat == '#'
      seat
    end
  end

  def part_2
    fill_seats do |state, r, c|
      count = 0
      [-1,0,1].each do |x|
        [-1,0,1].each do |y|
          next if x == 0 && y == 0
          rr, cc = r, c
          while true
            rr += x
            cc += y
            break if rr < 0 || cc < 0 || state[rr]? == nil || state[rr][cc]? == nil
            count += 1 if state[rr][cc] == '#'
            break unless state[rr][cc] == '.'
          end
        end
      end

      seat = state[r][c]
      seat = '#' if count == 0 && seat == 'L'
      seat = 'L' if count >= 5 && seat == '#'
      seat
    end
  end

  def print(state)
    state.each do |row|
      puts row.join
    end
    puts
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
