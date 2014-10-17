# encoding: UTF-8
require 'colorize'
require 'byebug'
require_relative 'piece.rb'

class Board

  attr_accessor :grid, :red_pieces, :black_pieces
  attr_reader :size

  def initialize(size = 8, dup = false)
    @size = size
    @grid = Array.new(size) { Array.new(size) { nil } }
    @red_pieces = 0
    @black_pieces = 0
    put_pieces_on_board unless dup
  end

  def put_pieces_on_board
    (0...@grid.length).each_with_index do |val, row|
      (0...@grid.length).each_with_index do |val, col|
        place_black_or_red_piece(row, col)
      end
    end
  end

  def display_board
    system("clear")
    puts 'Welcome to Checkers!'
    puts '   0 1 2 3 4 5 6 7'
    @grid.each_with_index do |val, row_index|
      print "#{row_index} "
      val.each_with_index do |val2, col_index|
        print get_piece_color(@grid[row_index][col_index], row_index, col_index) 
      end
      puts
    end
  end

  def move_piece(start_pos, end_pos)
    start_piece = self[start_pos]
    start_piece.current_pos = end_pos
    self[end_pos] = start_piece
    self[start_pos] = nil
    display_board
  end

  def on_board?(pos)
    row, col = pos
    row.between?(0,size) && col.between?(0,size)
  end
  
  def [](pos)
    row, col = pos
    @grid[row][col]
  end
  
  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end
  
  def remove_piece(pos)
    self[pos] == :red ? @red_pieces -= 1 : @black_pieces -= 1
    self[pos] = nil
    puts "removed square!"
  end

  def game_over?
    return true if (@black_pieces == 0 || @red_pieces == 0)
    return false
  end

  def combine_pos(old_pos, new_pos)
    [old_pos[0] + new_pos[0], old_pos[1] + new_pos[1]]
  end

  def check_middle_square(start_pos, end_pos, my_color)
    remove_squares = combine_pos(start_pos, end_pos)
    remove_squares.map! {|pos| pos / 2}
    !self[remove_squares].nil? && self[remove_squares].color != my_color
  end

  def get_middle_square(start_pos, end_pos)
    remove_squares = combine_pos(start_pos, end_pos)
    remove_squares.map! {|pos| pos / 2}
    remove_squares
  end

  def dup
    new_board = self.class.new(size, true)
    each_piece do |el, row, col|
      if !el.nil?
        new_board[[row, col]] = el.class.new(new_board, [row, col], el.color)
      end 
    end
    new_board
  end

  private

    def place_black_or_red_piece(row, col)
      if row.between?(5,7)
        if row.odd? && col.odd? || row.even? && col.even?
            @grid[row][col] = Piece.new(self, [row, col], :black)
            @black_pieces += 1
        end
      elsif row.between?(0,2)
        if row.odd? && col.odd? || row.even? && col.even?
          @grid[row][col] = Piece.new(self, [row, col], :red)
          @red_pieces += 1
        end
      end
    end

    def get_piece_color(el, row_index, col_index)
      if !el.nil?
        if el.color == :red
          piece = "#{el.piece_unicode} "
        else
          piece = "#{el.piece_unicode} "
        end
      end

      if row_index.even? && col_index.odd? || col_index.even? && row_index.odd?
        processed_piece = el.nil? ? "  ".on_black : piece.on_black
      else
        processed_piece = el.nil? ? "  ".on_light_white : piece.on_light_white
      end
      print processed_piece
    end

    def each_piece
      if block_given?
        @grid.each_with_index do |row, row_index|
          row.each_with_index do |el, col_index|
            yield(el, row_index, col_index)
          end
        end
      end
    end

end



