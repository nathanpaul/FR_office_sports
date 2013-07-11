class PlayersController < ApplicationController
	before_action :sort_by_ELO

	def index
	end

	def new
		@player = Player.new
	end

	def create
		@player = Player.new(params[:player])
		@player.save
		redirect_to players_path
	end

	def sort_by_ELO
		$rank = 1

		Player.order("elo_rating DESC").each do |p|
			p.position = $rank
			$rank += 1;
			p.save
		end
	end
end
