prev, count = 2**31 - 1, 0

IO.readlines("sonar_sweep_input.txt").each do |line|
  current = line.to_i
  if current > prev
    count += 1
  end
  prev = current
end

print count

