require_relative 'board'
require_relative 'game'
require_relative 'cell'
require_relative 'chess_methods'
Dir["./pieces/*"].each {|file| require file }

game = Game.new
input = nil

puts "\nwelcome to chess. would you like to start a new game or load a saved game? [new/load]"

loop do
  input = gets.chomp.downcase
  break if ['new', 'load'].include?(input)
  puts "please enter 'new' or 'load'"
end

if input == 'new'
  game = Game.setup
  game.play
else
  puts "please enter the name of your save game:"
  save_game = gets.chomp
  game.load(save_game)
end



