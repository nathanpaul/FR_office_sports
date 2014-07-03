class Partner < ActiveRecord::Base
	belongs_to :player
	attr_accessible :partner_id, :win_count, :loss_count, :win_streak, :lose_streak, :current_streak, :player_id
end
