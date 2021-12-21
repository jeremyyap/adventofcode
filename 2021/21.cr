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
    turn_1 = true
    score_1 = score_2 = roll_count = 0
    pos_1, pos_2 = @player_1_start, @player_2_start
    until score_1 >= 1000 || score_2 >= 1000
      move = 3.times.sum { deterministic_die.next.as(Int32) }
      roll_count += 3
      if turn_1
        pos_1, score_1 = move_and_score(pos_1, score_1, move)
      else
        pos_2, score_2 = move_and_score(pos_2, score_2, move)
      end
      turn_1 = !turn_1
    end
    roll_count * [score_1, score_2].min
  end

  @@quantum_dice_outcomes = [{3,1}, {4,3}, {5,6}, {6,7}, {7,6}, {8,3}, {9,1}]

  def simulate(p1pos, p1score, p2pos, p2score, turn1)
    return 1_i64, 0_i64 if p1score >= 21
    return 0_i64, 1_i64 if p2score >= 21

    p1wins = p2wins = 0_i64
    @@quantum_dice_outcomes.each do |(move, universes)|
      if turn1
        new_p1pos, new_p1score = move_and_score(p1pos, p1score, move)
        new_p2pos, new_p2score = p2pos, p2score
      else
        new_p1pos, new_p1score = p1pos, p1score
        new_p2pos, new_p2score = move_and_score(p2pos, p2score, move)
      end
      c, d = simulate(new_p1pos, new_p1score, new_p2pos, new_p2score, !turn1)
      p1wins += c * universes
      p2wins += d * universes
    end

    return p1wins, p2wins
  end

  def part_2
    puts simulate(@player_1_start, 0, @player_2_start, 0, true).max
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
