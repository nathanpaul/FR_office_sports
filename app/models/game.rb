class Game < ActiveRecord::Base
	belongs_to :player
	attr_accessible :remember_token, :winning_score, :losing_score, :blue_offense, :blue_defense, :red_offense, :red_defense, :blue_elo, :red_elo, :winner, :elo_swing
end
