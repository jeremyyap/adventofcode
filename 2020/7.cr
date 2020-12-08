class Program
  @rules: Hash(String, Array(Tuple(Int32, String)))

  def initialize
    @rules = Hash(String, Array(Tuple(Int32, String))).new
    File.read("7.txt")[0..-2].split('\n').each do |rule|
      container, contents = rule.split(" bags contain ")
      content_bags = contents.split(/(?: bag| bags)(?:,|\.)\s?/)[0..-2]

      tuples = content_bags.select { |str| str != "no other" }.map { |str| { str[0].to_i, str[2..-1] } }
      @rules[container] = tuples
    end
  end

  def can_contain(bag_type : String)
    @rules[bag_type].any? { |tuple| tuple[1] == "shiny gold" || can_contain(tuple[1]) }
  end

  def count_recursive(bag_type : String)
    @rules[bag_type].sum(0) { |tuple| (tuple[0] + tuple[0] * count_recursive(tuple[1])) }
  end

  def part_1
    @rules.keys.count { |bag_type| can_contain(bag_type) }
  end

  def part_2
    count_recursive("shiny gold")
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
