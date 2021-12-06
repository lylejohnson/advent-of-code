class Fish
  attr_reader :age
  
  def initialize(age)
    @age = age
  end
  
  # At the end of anotheer day, update my age
  # Return newly spawned fish, if any
  def live_one_day
    if @age == 0
      @age = 6
      Fish.new(8)
    else
      @age -= 1
      nil
    end
  end
  
  def inspect
    @age
  end
end

def get_ages(filename)
  IO.readlines(filename).map {|s| s.split(",") }.flatten.map {|s| s.to_i }
end

if __FILE__ == $0
  ages = get_ages("lanternfish.txt")
  
  puts "Initial State: #{ages}"
  
  fishies = ages.map {|age| Fish.new(age) }
  
  days = 0
  
  while days < 256
    babies = []
    fishies.each do |fish|
      offspring = fish.live_one_day
      if offspring
        babies.push(offspring)
      end
    end
    fishies = fishies.concat(babies)
  
    days += 1
    
    # puts "After #{days} days: #{fishies}"
  end
  
  puts "#{fishies.length} fish exist"
end