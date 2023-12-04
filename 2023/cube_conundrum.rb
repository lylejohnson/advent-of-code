class Group
  attr_reader :count
  attr_reader :color

  def initialize(group) # e.g. "5 blue"
    terms = group.split
    @count = terms[0].to_i
    @color = terms[1]
  end

  def red?
    @color == 'red'
  end

  def green?
    @color == 'green'
  end

  def blue?
    @color == 'blue'
  end

  def to_s
    "#{count} #{color}"
  end
end

def parse_groups(groups)
  groups.split(',').map {|term| term.strip }.map {|term| Group.new(term) }
end

class Subset
  attr_reader :groups

  def initialize(subset)
    @groups = parse_groups(subset)
    unless self.red_group
      @groups << Group.new('0 red')
    end
    unless self.green_group
      @groups << Group.new('0 green')
    end
    unless self.blue_group
      @groups << Group.new('0 blue')
    end
  end

  def red_group
    @groups.find {|group| group.red? }
  end

  def blue_group
    @groups.find {|group| group.blue? }
  end

  def green_group
    @groups.find {|group| group.green? }
  end

  def red_count
    self.red_group.count
  end

  def green_count
    self.green_group.count
  end

  def blue_count
    self.blue_group.count
  end
end

def parse_subsets(s)
  subsets = s.split(';').map {|term| term.strip }.map {|term| Subset.new(term) }
end

class Game
  attr_reader :id
  attr_reader :subsets

  def initialize(id, subsets)
    @id = id.to_i
    @subsets = subsets
  end

  def to_s
    "Game #{id}: #{subsets}"
  end

  def revealed_counts
    return [
      self.subsets.map {|subset| subset.red_count }.max,
      self.subsets.map {|subset| subset.green_count }.max,
      self.subsets.map {|subset| subset.blue_count }.max
    ]
  end

  def possible?(required_red_count, required_green_count, required_blue_count)
    revealed_red_count, revealed_green_count, revealed_blue_count = self.revealed_counts
    revealed_red_count <= required_red_count && revealed_blue_count <= required_blue_count && revealed_green_count <= required_green_count
  end

  def Game.from_string(s)
    if s =~ /Game (\d+): (.*)/
      id = $1
      subsets = parse_subsets($2)
      return Game.new(id, subsets)
    end
  end
end

games = []

IO.readlines('cube_conundrum.input.txt').each do |line|
  games << Game.from_string(line)
end

possible_games = games.filter {|game| game.possible?(12, 13, 14) }

possible_games.each do |game|
  puts "Game #{game.id} is possible: #{game}"
end

puts possible_games.sum {|game| game.id }