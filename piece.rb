# -*- coding: utf-8 -*-
class MoveNotValid < StandardError
end

class Piece

	attr_accessor :board
	attr_reader :piece_unicode, :color, :is_king, :current_pos

	def initialize(board, pos, color)
		@board = board
		@current_pos = pos
		@color = color
		@is_king = true
		@piece_unicode = (@color == :red ? "🔴" : "⚫")
	end

	def perform_slide(new_pos)
		if valid_slide?(current_pos, new_pos, is_king)
			@board.move_piece(current_pos, new_pos)
			set_new_current_position(new_pos)
		end
	end

	def perform_jump(new_pos)
		if valid_jump?(current_pos, new_pos, is_king)
			remove_piece(get_middle_square(current_pos, new_pos))
			@board.move_piece(current_pos, new_pos)
			set_new_current_position(new_pos)
		end
	end

	def set_new_current_position(new_pos)
    @current_pos = new_pos
  end

	def maybe_promote

	end

	def combine_pos(old_pos, new_pos)
		[old_pos[0] + new_pos[0], old_pos[1] + new_pos[1]]
	end

	def on_board?(pos)
    row, col = pos
    row.between?(0,7) && col.between?(0,7)
  end

  private

  	def valid_slide?(old_pos, new_pos, is_king) #add king logic later
    if @board[new_pos].nil?
      all_possible_slides(color).include?(new_pos)
    else
      raise MoveNotValid.new("Cannot move here!")
    end
  end

	def valid_jump?(old_pos, new_pos, is_king) #add king logic later
    if @board[new_pos].nil? && check_middle_square(old_pos, new_pos)
      all_possible_jumps(color).include?(new_pos)
    else
      raise MoveNotValid.new("Cannot jump here!")
    end
  end

	def poss_move_deltas(color)
		black_dirs = [[-1, -1], [-1, 1]]
		red_dirs = [[1, 1], [1, -1]]
		return black_dirs += red_dirs if self.is_king

		color == :red ? red_dirs : black_dirs
	end

	def poss_jump_deltas(color)
		black_dirs = [[-2, 2], [-2, 2]]
		red_dirs = [[2, 2], [2, -2]]
		return black_dirs += red_dirs if self.is_king

		color == :red ? red_dirs : black_dirs
	end

	def all_possible_slides(color)
		all_poss_slides = []
		deltas = poss_move_deltas(color)

		deltas.each do |coord|
			all_poss_slides << combine_pos(current_pos, coord)
		end
		all_poss_slides.select! do |coord|
			on_board?(coord)
		end
		all_poss_slides
	end

	def all_possible_jumps(color)
		all_poss_jumps = []
		deltas = poss_jump_deltas(color)

		deltas.each do |coord|
			all_poss_jumps << combine_pos(current_pos, coord)
		end

		all_poss_jumps.select! do |coord|
			on_board?(coord)
		end
		all_poss_jumps
	end

	def remove_piece(pos)
		@board[pos] = nil
	end

	def check_middle_square(start_pos, end_pos)
		remove_squares = combine_pos(start_pos, end_pos)
		remove_squares.map! {|pos| pos / 2}
		!@board[remove_squares].nil? && @board[remove_squares].color != self.color
	end

	def get_middle_square(start_pos, end_pos)
		remove_squares = combine_pos(start_pos, end_pos)
		remove_squares.map! {|pos| pos / 2}
		remove_squares
	end

end



