# -*- coding: utf-8 -*-

class Piece

	BLACK_DELTAS = [[-1, -1], [-1, 1]]
	RED_DELTAS = [[1, 1], [1, -1]]

	attr_accessor :board
	attr_reader :piece_unicode, :color, :is_king


	def initialize(board, pos, color)
		@board = board
		@current_pos = pos
		@color = color
		@is_king = false
		@piece_unicode = (@color == :red ? "🔴" : "⚫")
	end

	def poss_move_deltas(color)
			black_move_dirs = [[-1, -1], [-1, 1]]
			red_move_dirs = [[1, 1], [1, -1]]
			all_move_dirs = black_move_dirs += red_move_dirs if self.is_king
			color == :red ? red_move_dirs : black_move_dirs
	end

	def perform_slide(new_pos)

	end

	def perform_jump(new_pos)

	end

	def maybe_promote
	end

	def combine_pos(old_pos, new_pos)
		[old_pos[0] + new_pos[0], old_pos[1] + new_pos[1]]
	end

end