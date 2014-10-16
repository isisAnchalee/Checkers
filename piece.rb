# -*- coding: utf-8 -*-
# require_relative 'board.rb'

class Piece

	BLACK_DELTAS = [[-1, -1], [-1, 1]]
	RED_DELTAS = [[1, 1], [1, -1]]

	attr_accessor :board
	attr_reader :piece_unicode, :color


	def initialize(board, pos, color)
		@board = board
		@current_pos = pos
		@color = color
		@is_king = false
		@piece_unicode = (@color == :red ? "🔴" : "⚫")
	end


	def perform_slide(new_pos)
		
	end

	def perform_jump(new_pos)

	end

	def combine_pos(old_pos, new_pos)
		[old_pos[0] + new_pos[0], old_pos[1] + new_pos[1]]
	end

end