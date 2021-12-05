require './input.rb'
require 'pry'

class BingoBoard

  attr_accessor :rows, :win

  def initialize(five_line_array)
    @rows = five_line_array
    @win = false
  end

  def check_number(called_num)
    @rows.each do |row|
      if row.include?(called_num)
        index_to_replace = row.index(called_num)
        row[index_to_replace] = -1
      end
    end
  end

  def check_win
    @rows.each do |row|
      if row.sum == -5
        @win = true
      end
    end

    if @rows[0].length == 0
      print @rows
    end

    columns = @rows.transpose
    columns.each do |column|
      if column.sum == -5
        @win = true
      end
    end

    return @win
  end

  def board_score
    sum = 0
    @rows.each do |row|
      row.each{|num| sum += num if num != -1}
    end
    sum
  end

end


def parse_input(input)
  messy_array = input.split(/\n/).reject{|line| line.empty?}.map{|line| line.strip}

  numbers_to_call = messy_array.shift.split(",").map{|str| str.to_i}

  bingo_board_arrays = []
  messy_board_array = messy_array.reject{|line| line.empty?}

  until messy_board_array.length < 5
    almost_board = messy_board_array.shift(5)
    board = []
    almost_board.each do |row|
      board << row.strip.split(" ").map{|str| str.to_i}
    end
    bingo_board_arrays << board
  end

  bingo_boards = bingo_board_arrays.map{|board_array| BingoBoard.new(board_array)}

  {boards: bingo_boards, numbers_to_call: numbers_to_call}
end

# one day I'll learn to write real unit tests
# test = BingoBoard.new([[22, 13, 17, 11, 0], [8, 2, 23, 4, 24], [21, 9, 14, 16, 7], [6, 10, 3, 18, 5], [1, 12, 20, 15, 19]])

# [13,9,2,10,12,15].each do |num|
#   test.check_number(num)
# end

# test.check_win
# print test.win
# print test.board_score
# print test.rows

def play_bingo(input)
  game_items = parse_input(input)
  numbers_to_call = game_items[:numbers_to_call]
  boards = game_items[:boards]
  
  winner_found = false
  current_num_index = 0
  score = 0

  until winner_found || current_num_index > numbers_to_call.length-1
    num = numbers_to_call[current_num_index]
  
    boards.each do |board|
      board.check_number(num)
      winner = board.check_win
      if winner 
        score = num * board.board_score
        winner_found = true
      end
    end

    current_num_index += 1
  end

  puts score
end

# play_bingo(Input.day_4_sample_input)
play_bingo(Input.day_4_input)

# game_info = parse_input(Input.day_4_input)
# print game_info[:boards].count