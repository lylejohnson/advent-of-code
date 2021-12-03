def get_reports(filename)
  IO.readlines(filename).map {|s| s.to_i(2) }
end

BITS = 12

def count_zeroes_and_ones(reports, bit_position)
  zeroes, ones = 0, 0
  bitmask = 2**bit_position
  reports.each do |report|
    if report & bitmask === 0
      zeroes += 1
    else
      ones += 1
    end
  end
  return zeroes, ones
end

def get_most_common_value(reports, bit_position)
  zeroes, ones = count_zeroes_and_ones(reports, bit_position)
  zeroes > ones ? "0" : "1"
end

def get_least_common_value(reports, bit_position)
  zeroes, ones = count_zeroes_and_ones(reports, bit_position)
  zeroes <= ones ? "0" : "1"
end

def reports_with_value_in_position(reports, value, bit_position)
  bitmask = 2**bit_position
  reports.filter do |report|
    (value == "1" && (report & bitmask != 0)) || (value == "0" && (report & bitmask == 0))
  end
end

def get_oxygen_generator_reading(reports)
  o2_generator_reading = nil
  (BITS - 1).downto(0) do |bit_position|
    most_common_value = get_most_common_value(reports, bit_position)
    reports = reports_with_value_in_position(reports, most_common_value, bit_position)
    if reports.length == 1
      o2_generator_reading = reports[0]
      break
    end
  end
  o2_generator_reading
end

def get_co2_scrubber_rating(reports)
  co2_scrubber_rating = nil
  (BITS - 1).downto(0) do |bit_position|
    least_common_value = get_least_common_value(reports, bit_position)
    reports = reports_with_value_in_position(reports, least_common_value, bit_position)
    if reports.length == 1
      co2_scrubber_rating = reports[0]
      break
    end
  end
  co2_scrubber_rating
end

if __FILE__ == $0
  reports = get_reports("diagnostic_reports.txt")
  
  o2_generator_reading = get_oxygen_generator_reading(reports)
  puts o2_generator_reading
  
  co2_scrubber_rating = get_co2_scrubber_rating(reports)
  puts co2_scrubber_rating
  
  life_support_rating = o2_generator_reading * co2_scrubber_rating
  
  puts life_support_rating
end
