def get_ages(filename)
  IO.readlines(filename).map {|s| s.split(",") }.flatten.map {|s| s.to_i }
end

if __FILE__ == $0
  puts get_ages("lanternfish.txt")
end