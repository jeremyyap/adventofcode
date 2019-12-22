require "../utils/coordinate"

class Program
  @deck: Array(Int32)

  def initialize
    @deck_size = 10007
    @deck = (0...@deck_size).to_a
  end

  def deal_into_new_stack
    @deck.reverse!
  end

  def deal_with_increment(inc : Int32)
    temp = Array(Int32).new(@deck_size, 0)
    @deck.each_with_index do |card, index|
      temp[(index * inc) % @deck_size] = card
    end
    @deck = temp
  end

  def cut(cut : Int32)
    @deck = @deck[cut..-1] + @deck[0...cut]
  end

  def execute
    process = File.read("22.txt")[0..-2].split('\n')
    process.each do |step|
      puts step
      words = step.split(' ')
      if step == "deal into new stack"
        deal_into_new_stack
      elsif words[0] == "cut"
        cut(words[1].to_i)
      else
        deal_with_increment(words[-1].to_i)
      end
    end

    puts @deck.index(2019)
  end
end

Program.new.execute
