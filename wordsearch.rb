
require 'colorize'

$debug = true

$lines = <<HERE
SOMKELGBOFATRWMSME
XOSOIRALRBIHAEENUB
SECCOCAIURRIDLCOSO
DPNIKRESEEENNCNYIL
REEPANSTESTKEOEACG
PEALDLUSTREILMIRIL
PCDSLPSUAGFNAECCUL
KAHLMIDTYLAGCGSNAW
NIMOOENMUECCNICPSR
PWCANFFGYDMATHIRCI
SEITIVITCAIPACSEHT
FIELDTRIPRSENASLOI
KOOBETONAGHISROUON
TEACHERLEARNITRRLG
GNIDAERHDPPLESSONR
HERE

$width = $lines.split("\n").first.scan(/./).join(' ').size

words_to_find = %w(ART BACKPACK BUS CAFETERIA CALENDAR CLASSROOM COMPUTER CRAYONS DESK ERASER FOLDER FRIENDSHIP GLOBE GLUE GYM LUNCH MAP MUSIC PENCIL PRINCIPAL RULER SCIENCE SCISSOR SOCIALSTUDIES STUDENT THINKINGCAP WELCOME WRITING)

def debug(str)
  return unless $debug
  puts str
end

def print_board(x0, y0, x1, y1)
  x_range = ([x0, x1].min .. [x0, x1].max).to_a
  y_range = ([y0, y1].min .. [y0, y1].max).to_a

  x_range.reverse! if(x0 < x1)
  y_range.reverse! if(y0 < y1)

  if x_range.size != y_range.size
    red_letters = x_range.product(y_range)
  else
    red_letters = [x_range, y_range].transpose
  end

  puts ["x0:#{x0}", "y0:#{y0}", "x1:#{x1}", "y1:#{y1}"].join(', ')

  $lines.split("\n").each_with_index do |line, row|
    chars = line.scan(/./)
    chars.each_with_index do |char, col|
      if(red_letters.index([row, col]))
        print char.colorize(:red)
      else
        print char
      end
      print " "
    end
    puts
  end
end

def find(word)
  match = find_horizontal(word) || find_vertical(word) || find_diagnoal(word)
  puts match.inspect
  if match && match.size == 4
    puts " #{word} ".center($width, "*")
    #puts match.inspect
    print_board(*match)
  end
end

def find_horizontal(word)
  board = $lines.split("\n").map{|line| line.split(" ")}

  board.each_with_index do |row, index|
    line = row.join('')

    found = line.index(word)
    return [index, found, index, (found + word.size) - 1] if found

    found = line.reverse.index(word)
    return [index, line.size - found - word.size, index, line.size - found - 1] if found
  end
  nil
end

def find_vertical(word)
  board = $lines.split("\n").map{|line| line.scan(/./)}.transpose

  board.each_with_index do |col, index|
    line = col.join('')

    found = line.index(word)
    return [found, index, found + word.size - 1, index] if found

    found = line.reverse.index(word)
    return [line.size - found - word.size, index, line.size - found - 1, index] if found
  end
  nil
end

def find_diagnoal(word)
  lines = $lines.split("\n")

  height = lines.size

  width = lines.first.size

  #top left to bottom right
  width.times do |col_start|
    col = col_start
    str = ''

    height.times do |row|
      str += lines[row][col].to_s
      col += 1
    end

    found = str.index(word)
    return [found, col_start + found, found + word.size - 1, col_start + found + word.size - 1] if found

    found = str.reverse.index(word)
    if found
      found = str.size - found
      return [found - 1, col_start + found - 1, (height - (str.size - (word.size - found))).abs, col_start + found - word.size]
    end
  end
  
  #bottom left to top right
  width.times do |col_start|
    col = (width - (col_start + 1))
    str = ''

    height.times do |row|
      str += lines[row][col].to_s
      col -= 1
    end

    found = str.index(word)
    return [found, width - col_start - 1, found + word.size - 1, width - col_start - word.size] if found

    found = str.reverse.index(word)
    if found
      debug "reversed, bottom left to top right"
      debug "found: #{found}"
      debug "string: #{str}"
      debug "col start: #{col_start}"
      debug "string size: #{str.size}"
      debug "height: #{height}"
      debug "width: #{width}"
      debug "col: #{col}"
      return [height - found - 1, col_start - word.size, height - (found + word.size), col_start - 1]
    end
  end

  nil
end

puts "HI!".colorize(:white)
puts
puts

#top to bottom, left to right diag
#print_board(0, 0, 5, 5)


<<TABLE
S O M K E L G B O F A T R W M S M E 
X O S O I R A L R B I H A E E N U B 
S E C C O C A I U R R I D L C O S O 
D P N I K R E S E E E N N C N Y I L 
R E E P A N S T E S T K E O E A C G 
P E A L D L U S T R E I L M I R I L 
P C D S L P S U A G F N A E C C U L 
K A H L M I D T Y L A G C G S N A W 
N I M O O E N M U E C C N I C P S R 
P W C A N F F G Y D M A T H I R C I 
S E I T I V I T C A I P A C S E H T 
F I E L D T R I P R S E N A S L O I 
K O O B E T O N A G H I S R O U O N 
T E A C H E R L E A R N I T R R L G 
G N I D A E R H D P P L E S S O N R 
TABLE

#TODO: OLAR 
#TODO: LAICOS  BROKE vs SEIDUTS WORKS
#TODO: RALO
#TODO: DESK BROKE
#TODO: EEBHE
#TODO: SPELLING
#TODO: BUS
#TODO: COMPUTER
#TODO: GYM
#TODO: LUNCH
#TODO: MAP
#TODO: PENCIL
#TODO: PRINCIPAL
#TODO: STUDENT

#TODO bottom to top, left to right
#
#TEST:
#teacher
#reading
#socialstudies
#writing

total_tests = %w(olar laicos seiduts ralo desk eebhe spelling bus computer gym lunch map pencil principal student teacher reading socialstudies writing)

working = %w(olar laicos seiduts ralo)

total_tests = [(total_tests - working).first]

total_tests.each do |word|
  find(word.upcase)
end

#
#puts
#

find(ARGV[0].to_s.upcase) if ARGV[0]
