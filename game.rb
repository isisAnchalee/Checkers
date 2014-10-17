require_relative 'board.rb'
require 'yaml'
require 'io/console'

class Game
  
  def initialize
    @board = Board.new
    @current_turn = :black
  end
  
  def start_game
    puts "Would you like to load a game? (y/n)"
    input = gets.chomp
    if input.downcase == 'y'
      load_file("saved-game.txt").run_game
    else
      run_game
    end
  end
  
  def run_game
    system("clear")

    until @board.game_over?
      @board.display_board
      p "It's #{@current_turn.capitalize}'s turn"
      input = get_user_input
      if @board[input.shift].perform_moves(@current_turn, input)
        switch_turn
      end
    end

    winner_is
    exit
  end

  def switch_turn
    @current_turn = @current_turn == :red ? :black : :red
  end

  private
  
    def save_file
      File.open("saved-game.txt", "w") do |f|
        f.puts self.to_yaml
      end
      puts "Successfully saved."
      exit
    end
  
    def load_file(filename)
      yaml_str = File.read(filename)
      raise NoSavedGame if yaml_str.length == 0
      game_obj = YAML.load(yaml_str)
    end
    
    def after_move_output
      switch_turn
      system("clear")
      @board.display_board
    end

    def get_user_input
      puts "If you'd like to save, enter 's'."
      puts "E.G. 5142 or for chains 513315"
      input_1 = gets.chomp.split("")
      save_file if input_1.first == 's'
      i = 0
      moves = []
      while i < input_1.count
        moves << [input_1[i].to_i, input_1[i+1].to_i]
        i += 2
      end
      moves
    end
  
    def winner_is
      @board.display_board
      switch_turn
      puts "Congrats, #{@current_turn.capitalize} wins!"
    end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.start_game
end
