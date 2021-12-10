class Line
  attr_reader :first_illegal_char

  def initialize(s)
    @line = s
    @first_illegal_char = nil
    @completion_string = nil
    @autocomplete_score = nil
  end

  def to_s
    @line
  end

  def corrupted?
    unless @first_illegal_char
      stack = []
      @line.each_char do |c|
        if self.is_opener? c
          stack.push c
        elsif self.is_closer? c
          if self.is_legal?(stack.last, c)
            stack.pop
          else
            @first_illegal_char = c
            break
          end
        else
          puts "unrecognized char #{c}"
        end
      end
    end
    not @first_illegal_char.nil?
  end

  def is_opener? c
    ["(", "[", "<", "{"].include? c
  end

  def is_closer? c
    [")", "]", ">", "}"].include? c
  end

  def closer_for(opener)
    case opener
    when "("
      ")"
    when "["
      "]"
    when "<"
      ">"
    when "{"
      "}"
    end
  end

  def is_legal?(opener, closer)
    (opener == "(" && closer == ")") ||
    (opener == "[" && closer == "]") ||
    (opener == "<" && closer == ">") ||
    (opener == "{" && closer == "}")
  end

  def syntax_score
    case @first_illegal_char
    when ")"
      3
    when "]"
      57
    when "}"
      1197
    when ">"
      25137
    else
      0
    end
  end

  def completion_string
    unless @completion_string
      stack = []
      @line.each_char do |c|
        if self.is_opener? c
          stack.push c
        elsif self.is_closer? c
          stack.pop
        else
          puts "unrecognized char #{c}"
        end
      end

      @completion_string = ""
      until stack.empty?
        @completion_string += self.closer_for(stack.pop)
      end
    end
    @completion_string
  end

  def autocomplete_score
    unless @autocomplete_score
      scores = {")": 1, "]": 2, "}": 3, ">": 4}
      @autocomplete_score = 0
      self.completion_string.each_char do |c|
        @autocomplete_score *= 5
        @autocomplete_score += scores[c.to_sym]
      end
    end
    @autocomplete_score
  end
end

def get_lines(filename)
  IO.readlines(filename).map {|s| s.chomp }.map {|s| Line.new(s) }
end

if __FILE__ == $0
  lines = get_lines("syntax_scoring.txt")
  corrupted_lines = lines.filter {|line| line.corrupted? }
  puts "Syntax score: #{corrupted_lines.map {|line| line.syntax_score }.sum}"
  incomplete_lines = lines.filter {|line| not line.corrupted? }
  autocomplete_scores = incomplete_lines.map {|line| line.autocomplete_score }.sort
  puts "The middle autocomplete score is: #{autocomplete_scores[autocomplete_scores.length/2]}"
end