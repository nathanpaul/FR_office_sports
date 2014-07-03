class Player < ActiveRecord::Base
	validates_presence_of :name
	attr_accessible :remember_token, :name, :wins, :losses, :wins_on_offense, :losses_on_offense, :active
	attr_accessible :wins_on_defense, :losses_on_defense, :elo_rating, :points_for, :points_against, :overall_elo
	attr_accessible :win_streak, :loss_streak, :shutout_for, :shutout_against
	has_many :games
end
