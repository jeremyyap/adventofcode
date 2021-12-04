class Program
  @numbers: Array(Int32)
  @called_numbers: Set(Int32)
  @last_called: Int32
  @boards: Array(Array(Array(Int32)))

  def initialize
    input = File.read("4.txt")[0..-2].split("\n\n")
    @numbers = input[0].split(",").map { |c| c.to_i }
    @called_numbers = Set(Int32).new
    @last_called = -1

    @boards = input[1..-1].map do |board_input|
      board_input.split("\n") .map do |row|
        row.strip.split(/\s+/).map { |c| c.to_i }
      end
    end
  end

  def called?(number : Int32)
    @called_numbers.includes?(number)
  end

  def win?(board : Array(Array(Int32)))
    board.any? { |row| row.all? { |number| called?(number) } } ||
    0.upto(4).any? { |col| board.all? { |row| called?(row[col]) } }
  end

  def score(board)
    board.flatten.reject { |num| called?(num) }.sum * @last_called
  end

  def play_bingo
    @called_numbers = Set(Int32).new
    @last_called = -1
    @numbers.each do |number|
      @called_numbers.add(number)
      @last_called = number
      yield
    end
  end

  def part_1
    play_bingo do
      @boards.each do |board|
        return score(board) if win?(board)
      end
    end
  end

  def part_2
    winning_boards = Set(Int32).new
    play_bingo do
      @boards.each_with_index do |board, i|
        winning_boards.add(i) if !winning_boards.includes?(i) && win?(board)
        return score(board) if winning_boards.size == @boards.size
      end
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
