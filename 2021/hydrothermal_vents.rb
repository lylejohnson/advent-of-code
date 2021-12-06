class Point
  attr_reader :x, :y
  
  def initialize(x, y)
    @x, @y = x, y
  end
  
  def to_s
    "#{self.x},#{self.y}"
  end
end

class Line
  attr_reader :p1, :p2
  
  def initialize(p1, p2)
    @p1, @p2 = p1, p2
  end
  
  def horizontal?
    self.p1.y == self.p2.y
  end
  
  def vertical?
    self.p1.x == self.p2.x
  end 
  
  def to_s
    "#{p1} -> #{p2}"
  end
end

class Grid
  def initialize(lines)
    w, h = self.compute_grid_size(lines)
    @grid = Array.new(h) {|y| Array.new(w, 0) }
    lines.each {|line| self.place_line(line) }
  end
  
  def compute_grid_size(lines)
    w = lines.map {|line| [line.p1.x, line.p2.x] }.flatten.max 
    h = lines.map {|line| [line.p1.y, line.p2.y] }.flatten.max 
    return w + 1, h + 1
  end
  
  def increment(x, y)
    @grid[y][x] += 1
  end
  
  def place_line(line)
    if line.horizontal?
      x1, x2 = [line.p1.x, line.p2.x].sort
      y = line.p1.y
      x1.upto(x2) do |x|
        self.increment(x, y)
      end
    elsif line.vertical?
      y1, y2 = [line.p1.y, line.p2.y].sort
      x = line.p1.x
      y1.upto(y2) do |y|
        self.increment(x, y)
      end
    end
  end
  
  def to_s
    s = ""
    @grid.each do |row|
      s += row.map {|x| x != 0 ? x.to_s : "." }.join + "\n"
    end
    s
  end
  
  def overlaps
    count = 0
    @grid.each_with_index do |row, y|
      row.each_with_index do |value, x|
        if value > 1
          count += 1
        end
      end
    end
    count
  end
end

def get_lines(filename)
  IO.readlines(filename).map do |s|
    p1, p2 = s.split("->")
    x1, y1 = p1.split(",")
    x2, y2 = p2.split(",")
    Line.new(Point.new(x1.to_i, y1.to_i), Point.new(x2.to_i, y2.to_i))
  end
end

if __FILE__ == $0
  lines = get_lines("hydrothermal_vents.txt")

  # Only consider horizontal and vertical lines for now
  lines = lines.filter {|l| l.horizontal? or l.vertical? }
  
  grid = Grid.new(lines)
  puts grid
  puts
  puts "#{grid.overlaps} overlapping lines"
end
