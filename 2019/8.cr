width = 25
height = 6
area = width * height

transmission = File.read("8.txt").chars[0..-2]

num_layers = transmission.size // area

image = Array.new(height) { Array.new(width, ' ') }

(num_layers - 1).downto(0) do |i|
  start_index = i * area
  end_index = (i + 1) * area
  layer = transmission[start_index...end_index]

  layer.each_with_index do |pixel, index|
    x = index % width
    y = index // width
    if pixel == '1'
      image[y][x] = '*'
    elsif pixel == '0'
      image[y][x] = ' '
    end
  end
end

image.each { |row| puts row.join(' ') }
