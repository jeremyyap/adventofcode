def each_coordinate(grid : Array(Array(T))) forall T
  grid.each_index do |row|
    grid[row].each_index do |col|
      yield ({ row, col })
    end
  end
end

def each_with_coordinate(grid : Array(Array(T))) forall T
  grid.each_index do |row|
    grid[row].each_with_index do |cell, col|
      yield ({ cell, row, col })
    end
  end
end
