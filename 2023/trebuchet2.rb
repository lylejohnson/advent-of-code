DIGITS = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

def replace_digit_names(s)
  earliest_index, digit_index = s.length, -1
  DIGITS.each_with_index do |digit, idx|
    index = s.index(digit)
    if index && index < earliest_index
      earliest_index = index
      digit_index = idx
      puts "earliest_index = #{earliest_index}"
      puts "digit_index = #{digit_index}"
    end
  end
  if digit_index != -1
    s = s.sub(DIGITS[digit_index], (digit_index + 1).to_s)
  end

  latest_index, digit_index = -1, -1
  DIGITS.each_with_index do |digit, idx|
    index = s.rindex(digit)
    if index && index > latest_index
      latest_index = index
      digit_index = idx
      puts "latest_index = #{latest_index}"
      puts "digit_index = #{digit_index}"
    end
  end
  if digit_index != -1
    s = s.sub(DIGITS[digit_index], (digit_index + 1).to_s)
  end

  s
end

sum = 0

IO.readlines('trebuchet.input.txt').each do |s|
  puts "before: #{s}"
  s = replace_digit_names(s)
  puts "after: #{s}"
  first_digit_index = s.index(/\d/)
  last_digit_index = s.rindex(/\d/)
  calibration_value = s[first_digit_index] + s[last_digit_index]
  puts calibration_value
  sum += calibration_value.to_i
end

puts sum