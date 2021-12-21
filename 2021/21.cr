class Program
  def initialize
    @player_1_start = 10
    @player_2_start = 9
  end

  def move_and_score(pos, score, move)
    pos = (pos + move) % 10
    pos = 10 if pos == 0
    return pos, score + pos
  end

  def part_1
    deterministic_die = (1..100).cycle
    score_1 = score_2 = roll_count = 0
    pos_1, pos_2 = @player_1_start, @player_2_start
    until score_2 >= 1000
      move = 3.times.sum { deterministic_die.next.as(Int32) }
      roll_count += 3
      pos_1, score_1 = move_and_score(pos_1, score_1, move)
      pos_1, score_1, pos_2, score_2 = pos_2, score_2, pos_1, score_1
    end
    roll_count * score_1
  end

  @@quantum_dice_outcomes = [{3,1}, {4,3}, {5,6}, {6,7}, {7,6}, {8,3}, {9,1}]

  def simulate(pos_1, score_1, pos_2, score_2)
    return 0_i64, 1_i64 if score_2 >= 21

    wins_1 = wins_2 = 0_i64
    @@quantum_dice_outcomes.each do |(move, universes)|
      sub_wins_2, sub_wins_1 = simulate(pos_2, score_2, *move_and_score(pos_1, score_1, move))
      wins_1 += sub_wins_1 * universes
      wins_2 += sub_wins_2 * universes
    end

    return wins_1, wins_2
  end

  def part_2
    puts simulate(@player_1_start, 0, @player_2_start, 0).max
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
