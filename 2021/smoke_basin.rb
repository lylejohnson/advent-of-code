require 'set'

class Location
  attr_reader :height
  attr_reader :row
  attr_reader :col

  def initialize(row, col, height)
    @row = row
    @col = col
    @height = height
  end

  def risk_level
    @height + 1
  end

  def inspect
    @height
  end
end

class Basin
  def initialize(locations)
    @locations = locations
  end

  def inspect
    @locations.inspect
  end

  def size
    @locations.length
  end
end

class HeightMap
  def initialize(heights)
    @locations = []
    heights.each_with_index do |row, row_index|
      @locations[row_index] ||= []
      row.each_with_index do |height, col_index|
        @locations[row_index].push(Location.new(row_index, col_index, height))
      end
    end
  end

  def location_at(row, col)
    if row >= 0 && row < @locations.length && col >=0 && col < @locations[0].length
      @locations[row][col]
    else
      nil
    end
  end

  def adjacent_locations(row, col)
    [self.location_at(row -1, col), self.location_at(row, col+1), self.location_at(row+1, col), self.location_at(row, col-1)].filter {|loc| not loc.nil? }
  end

  def low_point?(loc)
    adjacent_heights = self.adjacent_locations(loc.row, loc.col).map {|loc| loc.height }
    loc.height < adjacent_heights.min
  end

  def low_points
    @locations.flatten.filter {|loc| self.low_point?(loc) }
  end

  def dfs(visited, current)
    visited.add(current)
    adjacent_locations = self.adjacent_locations(current.row, current.col)
    neighbors = adjacent_locations.filter {|loc| loc.height != 9 && loc.height > current.height }
    neighbors.each do |neighbor|
      if not visited.include? neighbor
        self.dfs(visited, neighbor)
      end
    end
  end

  def create_basin(low_point)
    locations = Set.new
    self.dfs(locations, low_point)
    Basin.new(locations.to_a)
  end

  def basins
    self.low_points.map do |loc|
      self.create_basin(loc)
    end
  end
end

def get_heightmap(filename)
  heights = IO.readlines(filename).map {|s| s.chomp.chars.map {|t| t.to_i } }
  HeightMap.new(heights)
end

if __FILE__ == $0
  heightmap = get_heightmap("smoke_basin.txt")

  low_points = heightmap.low_points
  puts "The sum of the risk levels for all low points is: #{low_points.map {|p| p.risk_level }.sum}"

  basins = heightmap.basins
  puts "There are #{basins.length} basins"

  largest_basins = heightmap.basins.sort_by {|basin| basin.size }.reverse.take(3)
  puts "The product of the sizes of the three largest basins is: #{largest_basins[0].size * largest_basins[1].size * largest_basins[2].size}"
end