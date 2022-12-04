class Program
  @inputs: Array(Tuple(Char, Char))

  def initialize
    rows = File.read("2.txt").chomp.split("\n")
    @inputs = rows.map { |row| { row[0], row[2] } }
  end

  def part_1
    shape_score = {
      'X' => 1,
      'Y' => 2,
      'Z' => 3
    }
    outcome_score = {
      'A' => {
        'X' => 3,
        'Y' => 6,
        'Z' => 0
      },
      'B' => {
        'X' => 0,
        'Y' => 3,
        'Z' => 6
      },
      'C' => {
        'X' => 6,
        'Y' => 0,
        'Z' => 3
      }
    }

    @inputs.sum do |opponent, me|
      shape_score[me] + outcome_score[opponent][me]
    end
  end

  def part_2
    outcome_score = {
      'X' => 0,
      'Y' => 3,
      'Z' => 6
    }
    shape_score = {
      'A' => {
        'X' => 3,
        'Y' => 1,
        'Z' => 2
      },
      'B' => {
        'X' => 1,
        'Y' => 2,
        'Z' => 3
      },
      'C' => {
        'X' => 2,
        'Y' => 3,
        'Z' => 1
      }
    }

    @inputs.sum do |opponent, outcome|
      outcome_score[outcome] + shape_score[opponent][outcome]
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
