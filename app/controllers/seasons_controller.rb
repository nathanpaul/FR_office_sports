class SeasonsController < ApplicationController
	def create
		@season = Season.new(params[:season])
		Season.update_all(:active => 0)
		@season.update(:active => 1)

		redirect_to players_path
	end
end
