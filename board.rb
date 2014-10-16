# encoding: UTF-8
require 'colorize'
require_relative 'piece.rb'

class Board

	attr_accessor :grid
	def initialize(size = 8)
		@size = size
		@grid = Array.new(@size){ Array.new(@size) }
		put_pieces_on_board
	end

	def put_pieces_on_board
		(0...@grid.length).each do |x|
			(0...@grid.length).each do |y|

				@grid[x][y] = Piece.new(self, [x, y])
			end
		end
	end

	  def place_tiles
    (0...@grid.length).each do |row|
      (0...@grid.length).each do |col|
        place_black_or_red_piece(row, col)
      end
    end
  end



	private

		def each_piece
      if block_given?
        @grid.each_with_index do |row, row_index|
          row.each_with_index do |el, col_index|
            yield(el, row_index, col_index)
          end
        end
      end
    end

    def place_black_or_red_piece
    	
    end

end

test = Board.new
test.display_board