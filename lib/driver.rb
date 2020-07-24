require_relative 'board'
require_relative 'game'
require_relative 'cell'
require_relative 'chess_methods'
Dir["./pieces/*"].each {|file| require file }

game = Game.setup
game.play

