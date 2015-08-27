#!/usr/bin/env ruby
#
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
  w = word.upcase
  match = find_horizontal(w) || find_vertical(w) || find_diagnoal(w)
  puts match.inspect
  if match && match.size == 4
    puts " #{w} ".center($width, "*")
    #puts match.inspect
  end
  match
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
  (-width .. width).each do |col_start|
    col = col_start
    str = ''

    height.times do |row|
      if col >= 0
        str += lines[row][col].to_s
      else
        str += '0'
      end
      col += 1
    end

    found = str.index(word)
    if found
      debug "bottom left to top right"
      debug "found: #{found}"
      debug "string: #{str}"
      debug "col start: #{col_start}"
      debug "string size: #{str.size}"
      debug "word size: #{word.size}"
      debug "height: #{height}"
      debug "width: #{width}"
      debug "col: #{col}"
      return [found, 
              col_start + found, 
              found + word.size - 1, 
              col_start + found + word.size - 1]
    end

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
      if col >= 0 
        str += lines[row][col].to_s
      else
        str += '0'
      end
      col -= 1
    end

    found = str.index(word)
    if found
    end

    return [found, 
            width - col_start - found - 1, 
            found + word.size - 1, 
            width - col_start - found - word.size] if found

    found = str.reverse.index(word)
    if found
      found = str.size - found
      return [height - (height - word.size) - 1 + (found - word.size), 
              width - col_start - word.size - (found - word.size), 
              height - (height - word.size) - word.size + (found - word.size), 
              width - col_start - 1 - (found - word.size)]
    end
  end

  nil
end


#top to bottom, left to right diag
#print_board(0, 0, 5, 5)


#TODO: EEBHE
#TODO: SPELLING
#TODO: LUNCH

#TODO bottom to top, left to right

if __FILE__ == $0
  puts "HI!".colorize(:white)
  puts
  puts

  if false
    total_tests = %w(olar laicos seiduts ralo desk eebhe spelling bus computer gym lunch map pencil principal student teacher reading socialstudies writing)
    
    working = %w(olar laicos seiduts ralo)
    
    total_tests = [(total_tests - working).first]
    
    total_tests.each do |word|
      print_board(*(find(word.upcase)))
    end
  end

  print_board(*find(ARGV[0].upcase))
end

#
#puts
#

find(ARGV[0].to_s.upcase) if ARGV[0]
