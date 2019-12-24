levels = Array.new(401) { Array.new(5) { Array.new(5) { '.' } } }
levels[200] = File.read("24.txt")[0..-2].split('\n').map(&.chars)
levels[200][2][2] = '?'

200.times do
  new_levels = Array.new(401) { Array.new(5) { Array.new(5) { '.' } } }
  levels.each_with_index do |grid, l|
    grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if i == 2 && j == 2
          new_levels[l][i][j] = '?'
          next
        end

        count = 0
        count += 1 if j < 4 && grid[i][j+1] == '#'
        count += 1 if j > 0 && grid[i][j-1] == '#'
        count += 1 if i < 4 && grid[i+1][j] == '#'
        count += 1 if i > 0 && grid[i-1][j] == '#'

        if (l > 0)
          (0..4).each { |j2| count += 1 if j == 2 && i == 1 && levels[l-1][0][j2] == '#' }
          (0..4).each { |j2| count += 1 if j == 2 && i == 3 && levels[l-1][4][j2] == '#' }
          (0..4).each { |i2| count += 1 if i == 2 && j == 1 && levels[l-1][i2][0] == '#' }
          (0..4).each { |i2| count += 1 if i == 2 && j == 3 && levels[l-1][i2][4] == '#' }
        end

        if (l < 400)
          count += 1 if i == 0 && levels[l+1][1][2] == '#'
          count += 1 if i == 4 && levels[l+1][3][2] == '#'
          count += 1 if j == 0 && levels[l+1][2][1] == '#'
          count += 1 if j == 4 && levels[l+1][2][3] == '#'
        end

        if grid[i][j] == '#' && count != 1
          new_levels[l][i][j] = '.'
        elsif grid[i][j] == '.' && (count == 1 || count == 2)
          new_levels[l][i][j] = '#'
        else
          new_levels[l][i][j] = grid[i][j]
        end
      end
    end
  end
  levels = new_levels
end

count = 0
levels.each_with_index do |grid, l|
  grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      count += 1 if cell == '#'
    end
  end
end
puts count
