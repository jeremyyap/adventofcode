require "set"
require "../utils/coordinate"

class Program
  @grid : Array(Array(Int32))

    def initialize
      @grid = File.read("8.txt").chomp.split("\n").map { |row| row.chars.map(&.to_i) }
    end

    def part_1
      visible_trees = Set(Coordinate).new()
      @grid.each_with_index do |row, y|
        max = -1
        row.each_with_index do |tree, x|
          if tree > max
            max = tree
            visible_trees.add({x,y})
          end
        end
        max = -1
        row.each_with_index.to_a.reverse_each do |tree, x|
          if tree > max
            max = tree
            visible_trees.add({x,y})
          end
        end
      end
      @grid[0].each_with_index do |col, x|
        max = -1
        @grid.each_index do |y|
          tree = @grid[y][x]
          if tree > max
            max = tree
            visible_trees.add({x,y})
          end
        end
        max = -1
        @grid.each_index.to_a.reverse_each do |y|
          tree = @grid[y][x]
          if tree > max
            max = tree
            visible_trees.add({x,y})
          end
        end
      end
      visible_trees.size
    end

    def part_2
      best = 0
      @grid.each_with_index do |row, y|
        row.each_with_index do |tree, x|
          score = 1
          dirs = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
          dirs.each do |dx, dy|
            xx, yy = x + dx, y + dy
            dir_score = 0
            while @grid[yy]? != nil && @grid[yy][xx]? != nil && @grid[yy][xx] < @grid[y][x] && yy >= 0 && xx >= 0
              dir_score += 1
              xx, yy = xx + dx, yy + dy
            end
            dir_score += 1 if @grid[yy]? != nil && @grid[yy][xx]? != nil && yy >= 0 && xx >= 0
            score *= dir_score
          end
          best = [best, score].max
        end
      end
      best
    end

    def execute
      puts part_1
      puts part_2
    end
  end

  Program.new.execute