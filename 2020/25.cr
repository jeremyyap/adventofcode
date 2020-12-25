class Program
  @card_public_key : Int32
  @door_public_key : Int32

  def initialize
    input = File.read("25.txt")[0..-2].split("\n")
    @card_public_key = input[0].to_i
    @door_public_key = input[1].to_i
  end

  def transform(loop_size, subject_number : Int32)
    number = 1_i64
    loop_size.times do
      number = (number * subject_number) % 20201227
    end
    number
  end

  def search(public_key, subject_number)
    number, loop_size = 1, 1
    while true
      number = (number * subject_number) % 20201227
      return loop_size if number == public_key
      loop_size += 1
    end
    return -1
  end

  def execute
    card_loop_size = search(@card_public_key, 7)
    door_loop_size = search(@door_public_key, 7)

    puts transform(card_loop_size, @door_public_key)
    puts transform(door_loop_size, @card_public_key)
  end
end

Program.new.execute
