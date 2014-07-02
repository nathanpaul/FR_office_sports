class PlayersController < ApplicationController
	before_action :sort_by_elo
	helper_method :sort_column, :sort_direction

	def show

	end

	def index
		@season = Season.new
		@game = Game.new
		@player = Player.new
	end

	def new
		@player = Player.new
	end

	def create
		@player = Player.new(params[:player])
		@player.save
		redirect_to players_path
	end

	def update
		@player = Player.find(params[:id])
		@player.update(params[:player])
		redirect_to players_path
	end

	def new_game
		respond_to do |format|
			format.js
		end
	end

	def sort_active
		session[:active_var] = 1
		redirect_to players_path
	end

	def sort_inactive
		session[:active_var] = 0
		redirect_to players_path
	end

	def sort_by_elo

		#Set player tab
		if session[:active_var] == nil
			session[:active_var] = 1
		end
		@player_list = Player.where(:active => session[:active_var]).order("overall_elo DESC")

		#Set current season
		@current_season = Season.where(:active => 1).first
		if @current_season == nil
			@current_season = Season.create(:name => "Summer 2014", :active => 1)
		end

		#Set 'last game' variables
		$last_game = Game.last
		if $last_game != nil
			$last_game_red_o = Player.find($last_game.red_offense)
			$last_game_red_d = Player.find($last_game.red_defense)
			$last_game_blue_o = Player.find($last_game.blue_offense)
			$last_game_blue_d = Player.find($last_game.blue_defense)
		end

		# $rank = 1
		# if Player.first != nil
		# 	$previous_rank = Player.order("elo_rating DESC").first.elo_rating
		# end

		# Player.order("elo_rating DESC").each do |p|
		# 	if p.elo_rating == $previous_rank
		# 		p.position = $rank
		# 	else
		# 		$rank += 1
		# 		p.position = $rank
		# 	end
		# 	$previous_rank = p.elo_rating
		# 	p.save
		# end
	end
end
