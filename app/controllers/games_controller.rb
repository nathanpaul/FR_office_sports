class GamesController < ApplicationController

	def new
		@game = Game.new
	end

	def create
		@game = Game.new(params[:game])
		calc_and_update_ELO		
		@game.save
		redirect_to players_path
	end

	private

	def calc_and_update_ELO

		$player1 = Player.where(:name => @game.blue_offense).first
		$player2 = Player.where(:name => @game.blue_defense).first

		@game.blue_ELO = ($player1.ELO_rating + $player2.ELO_rating) / 2

		$player1 = Player.where(:name => @game.red_offense).first
		$player2 = Player.where(:name => @game.red_defense).first

		@game.red_ELO = ($player1.ELO_rating + $player2.ELO_rating) / 2


		Player.where(:name => @game.blue_offense).first.games << @game
		Player.where(:name => @game.blue_defense).first.games << @game
		Player.where(:name => @game.red_offense).first.games << @game
		Player.where(:name => @game.red_defense).first.games << @game
	end
end
