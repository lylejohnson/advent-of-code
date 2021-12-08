def get_signal_patterns_and_outputs(filename)
  IO.readlines(filename).map do |entry|
    left, right = entry.split("|")
    signal_patterns = left.split(" ")
    digits = right.split(" ")
    [signal_patterns, digits]
  end
end

def sort_alpha(s)
  s.split("").sort.join
end

#
# Given a set of signal patterns, determine which signals
# correspond to which segments.
#
def get_signal_to_segment_map(signal_patterns)
  patterns_by_length = {}
  signal_patterns.each do |pattern|
    patterns_by_length[pattern.length] ||= []
    patterns_by_length[pattern.length].push(pattern)
  end

  m = {}

  # There's only one pattern of length 2, and it tells us
  # which signals correspond to segments C and F (but not
  # which is which).
  pattern2 = patterns_by_length[2][0].split("")

  # The signal that maps to F appears in all but one pattern (i.e. nine of the ten patterns).
  counts = [0, 0]
  patterns_by_length.each_value do |patterns|
    patterns.each do |pattern|
      signals = pattern.split("")
      if signals.include?(pattern2[0])
        counts[0] += 1
      end
      if signals.include?(pattern2[1])
        counts[1] += 1
      end
    end
  end

  if counts[0] == 9
    m[pattern2[0]] = 'f'
    m[pattern2[1]] = 'c'
  elsif counts[1] == 9
    m[pattern2[1]] = 'f'
    m[pattern2[0]] = 'c'
  end

  # There's only one pattern of length 3, and we can
  # use our CF pattern to deduce what signal maps to A.
  pattern3 = patterns_by_length[3][0].split("")
  signal_for_a = (pattern3 - pattern2).join
  m[signal_for_a] = 'a'

  # Of the three 5-length patterns, there are two signals
  # that only appear once. Those two signals map to B and E.
  pattern5 = patterns_by_length[5]
  counts = {}
  pattern5.each do |pattern|
    signals = pattern.split("")
    signals.each do |signal|
      counts[signal] ||= 0
      counts[signal] += 1
    end
  end
  pattern5be = counts.keys.filter {|key| counts[key] == 1 }

  # There's only one pattern of length 4, and we can
  # use the data we have so far to determine which signals
  # map to B and D.
  pattern4 = patterns_by_length[4][0].split("")
  pattern4_minus_cf = pattern4 - pattern2
  pattern4_only_d = pattern4_minus_cf - pattern5be
  pattern4_only_b = pattern4_minus_cf - pattern4_only_d

  m[pattern4_only_d[0]] = 'd'
  m[pattern4_only_b[0]] = 'b'

  # The signal that maps to G appears in all three of the 5-length patterns
  signals_e_and_g = ['a', 'b', 'c', 'd', 'e', 'f', 'g'] - m.keys
  if pattern5.map {|pattern| pattern.split("") }.all? {|signals| signals.include?(signals_e_and_g[0]) }
    m[signals_e_and_g[0]] = 'g'
    m[signals_e_and_g[1]] = 'e'
  elsif pattern5.map {|pattern| pattern.split("") }.all? {|signals| signals.include?(signals_e_and_g[1]) }
    m[signals_e_and_g[1]] = 'g'
    m[signals_e_and_g[0]] = 'e'
  end

  return m
end

#
# Given a digit like "cdfeb", map each of the signals to
# the correct signal values, and from that we can know
# which value the 7-segment display is showing
#
def map_digit_to_segments(signal_to_segment_map, digit)
  digit.split("").map {|s| signal_to_segment_map[s] }.sort.join
end

def map_segments_to_value(segments)
  segments_to_values = {
    abcefg: 0,
    cf: 1,
    acdeg: 2,
    acdfg: 3,
    bcdf: 4,
    abdfg: 5,
    abdefg: 6,
    acf: 7,
    abcdefg: 8,
    abcdfg: 9
  }
  values = segments.map {|segment| segments_to_values[segment.to_sym] } # an array of numbers, e.g [0, 1, 2, 3]
  values.map {|v| v.to_s }.join.to_i
end

if __FILE__ == $0
  pairs = get_signal_patterns_and_outputs("7segment.txt")
  values = pairs.map do |pair|
    signal_patterns, digits = pair

    signal_patterns = signal_patterns.map {|s| sort_alpha(s) }

    signal_to_segment_map = get_signal_to_segment_map(signal_patterns)
    segments = digits.map {|digit| map_digit_to_segments(signal_to_segment_map, digit) }
    map_segments_to_value(segments)
  end
  puts values.sum
end
