def get_crab_positions(filename)
  rows = IO.readlines(filename).map do |s|
    tokens = s.split(",")
    positions = tokens.map {|s| s.to_i }
  end
  rows.flatten
end

def cost_to_align_one_crab_to_position(crab_position, desired_position)
  n = (crab_position - desired_position).abs
  n * (n + 1) / 2
end

def cost_to_align_all_crabs_to_position(crab_positions, desired_position)
  crab_positions.map {|crab_position| cost_to_align_one_crab_to_position(crab_position, desired_position) }.sum
end

if __FILE__ == $0
  crab_positions = get_crab_positions("whales.txt")
  min_position = crab_positions.min
  max_position = crab_positions.max

  costs = (min_position..max_position).to_a.map do |desired_position|
    cost_to_align_all_crabs_to_position(crab_positions, desired_position)
  end

  min_cost = costs.min

  puts min_cost
end
