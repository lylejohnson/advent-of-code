class Row
  def initialize(cells)
    @cells = cells
  end
  
  def completed?
    @cells.all? {|c| c.marked? }
  end
end

class Column
  def initialize(cells)
    @cells = cells
  end
  
  def completed?
    @cells.all? {|c| c.marked? }
  end
end

class Cell
  attr_reader :value

  def initialize(value)
    @value = value
    @marked = false
  end
  
  def mark
    @marked = true
  end
  
  def marked?
    @marked
  end
end

class Board
  def initialize(data)
    @winning_number = nil
    @cells, @rows, @columns = self.build_rows_and_columns(data)
  end
  
  def build_rows_and_columns(data)
    cells, rows, columns = [], [], []
    data.each_with_index do |r, row_index|
      row = []
      r.each_with_index do |value, col_index|
        cell = Cell.new(value)
        cells.push(cell)
        row.push(cell)
        columns[col_index] ||= []
        columns[col_index].push(cell)
      end
      rows.push(row)
    end
    return cells, rows.map {|r| Row.new(r) }, columns.map {|c| Column.new(c) }
  end
  
  def pick(number)
    cell = self.find_cell(number)
    if cell
      cell.mark
      if self.has_bingo? and not @winning_number
        @winning_number = number
      end
    end
  end
  
  def find_cell(number)
    self.cells.find {|c| c.value == number }
  end
  
  def cells
    @cells
  end
  
  def rows
    @rows
  end
  
  def columns
    @columns
  end
  
  def has_bingo?
    self.rows.any? {|r| r.completed? } || self.columns.any? {|c| c.completed? }
  end
  
  def unmarked_numbers
    self.cells.filter {|c| !c.marked? }.map {|c| c.value }
  end
  
  def score
    self.unmarked_numbers.sum * @winning_number
  end
end

def get_game_input(filename)
  lines = IO.readlines(filename)
  
  numbers = lines[0].split(",").map {|p| p.to_i }
  
  offset = 2
  boards = []
  
  while offset < lines.length
    data = []
    5.times do |i|
      data.push(lines[offset + i].split.map {|p| p.to_i })
    end
    
    boards.push(Board.new(data))
    
    offset += 6
  end  

  return numbers, boards
end

if __FILE__ == $0
  numbers, boards = get_game_input("bingo_input.txt")
  first_winner = nil
  latest_winner = nil
  
  numbers.each do |number|
    puts "Picked number #{number}..."
        
    boards.each do |board|
      board.pick(number)
    end

    # Check for winners
    boards.each do |board|
      if board.has_bingo?
        if not first_winner
          first_winner = board
        else
          latest_winner = board
        end
        boards.delete(board)
      end
    end
    
    if boards.empty?
      puts "No more players left!"
      break
    else
      puts "#{boards.length} boards still in play!"
    end
  end
  
  puts "First winning board score: #{first_winner.score}"
  puts latest_winner
  puts "Last winning board score: #{latest_winner.score}"
end
