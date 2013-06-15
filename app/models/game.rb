class Game < ActiveRecord::Base
	belongs_to :player
	attr_accessible :winning_score, :losing_score, :blue_offense, :blue_defense, :red_offense, :red_defense, :blue_ELO, :red_ELO, :winner
end
