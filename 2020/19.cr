class Program
  @rules : Hash(Int32, String)
  @messages : Array(String)
  @memo : Hash(String, Bool)

  def initialize
    rules, messages = File.read("19.txt")[0..-2].split("\n\n")

    @rules = Hash(Int32, String).new
    rules.split('\n').each do |rule|
      id, str = rule.split(": ")
      @rules[id.to_i] = str
    end
    @messages = messages.split('\n')
    @memo = Hash(String, Bool).new
  end

  def test(message : String, rule_id : Int32)
    return @memo[message + rule_id.to_s] if @memo[message + rule_id.to_s]?
    rule = @rules[rule_id]
    return message == rule[1..1] if rule == "\"a\"" || rule == "\"b\""

    lists = rule.split(" | ")
    result = lists.any? do |list|
      sub_rule = list.split(" ")
      next test(message, sub_rule[0].to_i) if sub_rule.size == 1
      rule1, rule2 = sub_rule
      (1...message.size).any? do |i|
        test(message[0...i], rule1.to_i) && test(message[i..-1], rule2.to_i)
      end
    end
    @memo[message + rule_id.to_s] = result
  end

  def part_1
    # Observation: Rule 8 & 11 only match 8-character strings
    @messages.count { |message| message.size == 24 && test(message, 0) }
  end

  def part_2
    # 0: 8 | 11
    # 8: 42 | 42 8
    # 11: 42 31 | 42 11 31
    # 11: 42{m} 42{n} 31{n} where m ≥ 1, n ≥ 1
    # Observation: Rule 8 & 11 only match 8-character strings
    @messages.count do |message|
      count_42, count_31, i, j = 0, 0, 0, 8
      while test(message[i...j], 42)
        count_42 += 1
        i += 8
        j += 8
      end

      while test(message[i...j], 31)
        count_31 += 1
        i += 8
        j += 8
      end
      (count_31 + count_42) * 8 == message.size && # Exact match
        count_42 - count_31 >= 1 &&                # More rule 42 than rule 31
        test(message[-8..-1], 31)                  # At least 1 rule 31
    end
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
