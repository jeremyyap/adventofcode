def passwords(first, last)
  (first..last).count do |x|
    digits = x.to_s.split("").map(&.to_i)
    is_ascending = digits.each_cons(2).all? { |cons| cons[0] <= cons[1] }
    digits.unshift(0).push(0)
    has_pair = digits.each_cons(4).any? { |cons| cons[0] != cons[1] && cons[1] == cons[2] && cons[2] != cons[3] }
    is_ascending && has_pair
  end
end

puts passwords(197487, 673251)
