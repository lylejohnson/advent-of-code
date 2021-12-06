class Population
  def initialize(ages)
    @generations = Array.new(9, 0)
    ages.each {|age| @generations[age] += 1 }
  end

  def age_one_day
    zeroes = @generations[0]
    
    @generations[0] = @generations[1]
    @generations[1] = @generations[2]
    @generations[2] = @generations[3]
    @generations[3] = @generations[4]
    @generations[4] = @generations[5]
    @generations[5] = @generations[6]
    @generations[6] = @generations[7] + zeroes
    @generations[7] = @generations[8]
    @generations[8] = zeroes
  end
  
  def size
    @generations.sum
  end
end

def get_ages(filename)
  IO.readlines(filename).map {|s| s.split(",") }.flatten.map {|s| s.to_i }
end

if __FILE__ == $0
  ages = get_ages("lanternfish.txt")
  
  population = Population.new(ages)

  MAX_DAYS = 256
  days = 0
  
  while days < MAX_DAYS
    population.age_one_day
    days += 1
  end
  
  puts "#{population.size} fish exist after #{MAX_DAYS} days"
end