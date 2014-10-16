# encoding: UTF-8
require 'colorize'
require_relative 'piece.rb'

class Board

  attr_accessor :grid
  attr_reader :size

  def initialize(size = 8)
    @size = size
    @grid = Array.new(size) { Array.new(size) { nil } }
    put_pieces_on_board
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
    self[end_pos] = start_piece
    self[start_pos] = nil
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
    self[pos] = nil
    puts "removed square!"
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

  private

    def place_black_or_red_piece(row, col)
      if row.between?(5,7)
        if row.odd? && col.odd? || row.even? && col.even?
          @grid[row][col] = Piece.new(self, [row, col], :black)
        end
      elsif row.between?(0,2)
        if row.odd? && col.odd? || row.even? && col.even?
          @grid[row][col] = Piece.new(self, [row, col], :red)
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

test = Board.new
test[[5,1]].perform_slide([4,0])
test.display_board

