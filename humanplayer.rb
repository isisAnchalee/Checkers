require_relative 'board'
class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    puts board.render
    puts "Current player: #{color}"

    from_pos = get_pos('From pos:')
    to_pos = get_pos('To pos:')
    board.move_piece(color, from_pos, to_pos)
  rescue StandardError => e
    puts "Error: #{e.message}"
    retry
  end

  private

  def get_pos(prompt)
    puts prompt
    gets.chomp.split(',').map { |coord_s| Integer(coord_s) }
  end
end