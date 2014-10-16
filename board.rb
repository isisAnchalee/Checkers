# encoding: UTF-8
require 'colorize'
require_relative 'piece.rb'

class Board

	attr_accessor :grid

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
    @grid.each_with_index do |val, row_index|
      val.each_with_index do |val2, col_index|
       print get_piece_color(@grid[row_index][col_index], row_index, col_index) 
      end
      puts
    end
  end

  def valid_slide?(old_pos, new_pos)

  end

  def valid_jump?(old_pos, new_pos)
  end

  def on_board?(pos)
    row, col = pos
    row.between?(0, size - 1) && col.between?(0, size - 1)
  end

	private

    def place_black_or_red_piece(row, col)
      if row.odd? && col.odd? || row.even? && col.even?
        if row.between?(5,7)
          @grid[row][col] = Piece.new(self, [row, col], :black)
        end
      elsif row.even? && col.odd? || row.odd? && col.odd?
        if row.between?(0,2)
          @grid[row][col] = Piece.new(self, [row, col], :red)
        end
      end
    end

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
test.display_board