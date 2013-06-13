class PlayersController < ApplicationController

	def index
	end

	def new
		@player = Player.new
	end

	def create
		@player = Player.new(params[:player])
		@player.save
		redirect_to :back
	end
end
