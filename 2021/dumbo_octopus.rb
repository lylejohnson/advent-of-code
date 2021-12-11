def get_initial_energy_levels(filename)
  IO.readlines(filename).map do |line|
    line.chomp.split("").map {|c| c.to_i }
  end
end

if __FILE__ == $0
  energy_levels = get_initial_energy_levels("dumbo_octopus.txt")
  puts energy_levels.inspect
end