require "big"

class Program
  @inputs: Array(Hash(String, String))

  def initialize
    @inputs = File.read("4.txt")[0..-2].split("\n\n").map do |passport|
      passport.split(/\s+/).map { |field| field.split(":") }.to_h
    end
  end

  def execute
    result = @inputs.count do |passport|
      passport.has_key?("byr") &&
      passport.has_key?("iyr") &&
      passport.has_key?("eyr") &&
      passport.has_key?("hgt") &&
      passport.has_key?("hcl") &&
      passport.has_key?("ecl") &&
      passport.has_key?("pid") &&
      passport["byr"].to_i >= 1920 && passport["byr"].to_i <= 2002 &&
      passport["iyr"].to_i >= 2010 && passport["iyr"].to_i <= 2020 &&
      passport["eyr"].to_i >= 2020 && passport["eyr"].to_i <= 2030 && (
        (passport["hgt"].ends_with?("cm") &&
          passport["hgt"][0..-3].to_i >= 150 &&
          passport["hgt"][0..-3].to_i <= 193) ||
        (passport["hgt"].ends_with?("in") &&
          passport["hgt"][0..-3].to_i >= 59 &&
          passport["hgt"][0..-3].to_i <= 76)
      ) &&
      passport["hcl"].match(/^#[0-9a-f]{6}$/) &&
      passport["ecl"].match(/^amb|blu|brn|gry|grn|hzl|oth$/) &&
      passport["pid"].match(/^[0-9]{9}$/)
    end
    puts result
  end
end

Program.new.execute
