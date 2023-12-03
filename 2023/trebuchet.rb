sum = 0
IO.readlines('trebuchet.input.txt').each do |s|
  puts s
  first_digit_index = s.index(/\d/)
  last_digit_index = s.rindex(/\d/)
  calibration_value = s[first_digit_index] + s[last_digit_index]
  sum += calibration_value.to_i
end

puts sum