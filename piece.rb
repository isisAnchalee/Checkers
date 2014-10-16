# -*- coding: utf-8 -*-

class InvalidMoveError < StandardError
end

class Piece

	attr_accessor :board, :is_king, :current_pos
	attr_reader :color, :current_pos

	def initialize(board, pos, color)
		@board = board
		@current_pos = pos
		@color = color
		@is_king = false
	end

	def piece_unicode
		(@color == :red ? "🔴" : "⚫")
	end

	def perform_slide(new_pos)
		if valid_slide?(current_pos, new_pos)
			@board.move_piece(current_pos, new_pos)
			current_pos = new_pos
			maybe_promote
		end
	end

	def perform_jump(new_pos)
		if valid_jump?(current_pos, new_pos)
			@board.remove_piece(@board.get_middle_square(current_pos, new_pos))
			@board.move_piece(current_pos, new_pos)
			current_pos = new_pos
			maybe_promote
		end
	end

	def maybe_promote
		@is_king = true if color == :red && current_pos.first == 7
		@is_king = true if color == :black && current_pos.first == 0
	end

  private

  def valid_slide?(old_pos, new_pos) #add king logic later
    if @board[new_pos].nil?
    	all_possible_slides(color).include?(new_pos)
    else
      raise InvalidMoveError.new("Cannot move here!")
    end
  end

	def valid_jump?(old_pos, new_pos)
    if @board[new_pos].nil? && @board.check_middle_square(old_pos, new_pos, self.color)
      all_possible_jumps(color).include?(new_pos)
    else
      raise InvalidMoveError.new("Cannot jump here!")
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
		poss_move_deltas(color).each do |coord|
			slide_pos = @board.combine_pos(current_pos, coord)
			all_poss_slides << slide_pos if @board.on_board?(slide_pos)
		end
		all_poss_slides
	end

	def all_possible_jumps(color)
		all_poss_jumps = []

		poss_jump_deltas(color).each do |coord|
			jump_pos = @board.combine_pos(current_pos, coord)
			all_poss_jumps << jump_pos if @board.on_board?(jump_pos)
		end
		all_poss_jumps
	end

end



