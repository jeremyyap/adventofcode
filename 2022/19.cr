class Blueprint
  getter id, ore_ore, clay_ore, obsidian_ore, obsidian_clay, geode_ore, geode_obsidian : Int32

  @id : Int32
  @ore_ore: Int32
  @clay_ore: Int32
  @obsidian_ore: Int32
  @obsidian_clay: Int32
  @geode_ore: Int32
  @geode_obsidian: Int32

  def initialize(specs : String)
    @id, @ore_ore, @clay_ore, @obsidian_ore, @obsidian_clay, @geode_ore, @geode_obsidian =
      specs.match(/^Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./)
      .try(&.captures).not_nil!.map(&.not_nil!).map(&.to_i)
  end
end

class Program
  @blueprints: Array(Blueprint)

  def initialize
    @blueprints = File.read("19.txt").chomp.split("\n").map { |row| Blueprint.new(row) }
  end

  def simulate(blueprint : Blueprint, ores : Int32, clays : Int32, obsidians : Int32, geodes : Int32,
               ore_robots : Int32, clay_robots : Int32, obsidian_robots : Int32, geode_robots : Int32, minutes : Int32)
    return geodes if minutes == 0
    outcomes = [] of Int32

    # build a geode robot
    if ores >= blueprint.geode_ore && obsidians >= blueprint.geode_obsidian
      return simulate(blueprint, ores + ore_robots - blueprint.geode_ore, clays + clay_robots, obsidians + obsidian_robots - blueprint.geode_obsidian, geodes + geode_robots,
                      ore_robots, clay_robots, obsidian_robots, geode_robots + 1, minutes - 1)

    # build an obsidian robot
    elsif ores >= blueprint.obsidian_ore && clays >= blueprint.obsidian_clay && obsidian_robots < blueprint.geode_obsidian
      outcomes << simulate(blueprint, ores + ore_robots - blueprint.obsidian_ore, clays + clay_robots - blueprint.obsidian_clay, obsidians + obsidian_robots, geodes + geode_robots,
                        ore_robots, clay_robots, obsidian_robots + 1, geode_robots, minutes - 1)

    # build a clay robot
    elsif ores >= blueprint.clay_ore && clay_robots < blueprint.obsidian_clay
      outcomes << simulate(blueprint, ores + ore_robots - blueprint.clay_ore, clays + clay_robots, obsidians + obsidian_robots, geodes + geode_robots,
                          ore_robots, clay_robots + 1, obsidian_robots, geode_robots, minutes - 1)
    end
    
    # build an ore robot
    if ores >= blueprint.ore_ore && (ore_robots < [blueprint.clay_ore, blueprint.obsidian_ore, blueprint.geode_ore].max)
      outcomes << simulate(blueprint, ores + ore_robots - blueprint.ore_ore, clays + clay_robots, obsidians + obsidian_robots, geodes + geode_robots,
                          ore_robots + 1, clay_robots, obsidian_robots, geode_robots, minutes - 1)
    end

    # don't build any new robots
    if ores < [blueprint.ore_ore, blueprint.clay_ore, blueprint.obsidian_ore, blueprint.geode_ore].max * 2
      outcomes << simulate(blueprint, ores + ore_robots, clays + clay_robots, obsidians + obsidian_robots, geodes + geode_robots,
                          ore_robots, clay_robots, obsidian_robots, geode_robots, minutes - 1)
    end

    outcomes.max
  end

  def max_geodes(blueprint : Blueprint, minutes : Int32)
    simulate(blueprint, 0, 0, 0, 0, 1, 0, 0, 0, minutes)
  end

  def part_1
    @blueprints.map { |blueprint| max_geodes(blueprint, 24) * blueprint.id }.sum
  end

  def part_2
    @blueprints.first(3).product { |blueprint| max_geodes(blueprint, 32) }
  end

  def execute
    puts part_1
    puts part_2
  end
end

Program.new.execute
