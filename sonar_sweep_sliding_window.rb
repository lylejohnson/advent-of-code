def sliding_windows(measurements, window_size = 3)
  window = []
  measurements.each do |measurement|
    window.push measurement
    if window.length > window_size
      window.shift
    end
    if window.length == window_size
      yield window
    end
  end
end

def read_measurements(filename)
  IO.readlines("sonar_sweep_input.txt").map {|s| s.to_i }
end

if __FILE__ == $0
  previous_sum = 2**31 - 1 # largest integer
  count = 0

  measurements = read_measurements("sonar_sweep_input.txt")

  sliding_windows(measurements) do |win|
    current_sum = win.sum
    if current_sum > previous_sum
      count += 1
    end
    previous_sum = current_sum
  end

  puts count
end