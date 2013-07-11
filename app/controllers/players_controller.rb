class PlayersController < ApplicationController
	before_action :sort_by_elo

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

	def sort_by_elo
		$rank = 1
		$previous_rank = 1500.0

		Player.order("elo_rating DESC").each do |p|
			if p.elo_rating == $previous_rank
				p.position = $rank
			else
				p.position = $rank
				$rank += 1
			end
			$previous_rank = p.elo_rating
			p.save
		end
	end
end
