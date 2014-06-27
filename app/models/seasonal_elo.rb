class SeasonalELO < ActiveRecord::Base
	belongs_to :player
	references :season
	attr_accessible :elo, :player_id, :season
end
