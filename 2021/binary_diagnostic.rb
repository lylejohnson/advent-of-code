def get_reports(filename)
  IO.readlines(filename).map {|s| s.to_i(2) }
end

def count(reports, bitmask)
  zeroes, ones = 0, 0
  reports.each do |report|
    if report & bitmask === 0
      zeroes += 1
    else
      ones += 1
    end
  end
  return zeroes, ones
end

if __FILE__ == $0
  reports = get_reports("diagnostic_reports.txt")
  
  gamma, epsilon = "", ""
  
  11.downto(0) do |i|
    zeroes, ones = count(reports, 2**i)
    gamma += ((zeroes > ones) ? "0" : "1")
    epsilon += ((zeroes > ones) ? "1" : "0")
  end
  
  power_consumption = gamma.to_i(2) * epsilon.to_i(2)
  
  puts power_consumption
end
