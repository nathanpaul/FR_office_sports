class GamesController < ApplicationController

	def new
		@game = Game.new
	end

	def create
		@game = Game.new(params[:game])
		if @game.password == "donttellneal"	
			calc_and_update_ELO			
			@game.save
			redirect_to players_path
		else
			@game.delete
			redirect_to new_game_path
		end
	end

	def random_game
		respond_to do |format|
			format.html
		end
	end

	def delete
		$player1 = Player.where(:name => @game.blue_offense).first
		$player2 = Player.where(:name => @game.blue_defense).first
		$player3 = Player.where(:name => @game.red_offense).first
		$player4 = Player.where(:name => @game.red_defense).first

		@game.blue_elo = ($player1.elo_rating + $player2.elo_rating) / 2
		@game.red_elo = ($player3.elo_rating + $player4.elo_rating) / 2

		$ELO_swing = 10

		if @game.blue_elo > @game.red_elo && @game.winner == "Blue Team"
			$ELO_swing = (10 + @game.winning_score - @game.losing_score)*((@game.red_elo / @game.blue_elo)/1.166667)
		elsif @game.blue_elo > @game.red_elo && @game.winner == "Red Team"
			$ELO_swing = (10 + @game.winning_score - @game.losing_score)*((@game.blue_elo / @game.red_elo)*1.166667)
		elsif @game.blue_elo < @game.red_elo && @game.winner == "Red Team"
			$ELO_swing = (10 + @game.winning_score - @game.losing_score)*((@game.blue_elo / @game.red_elo)/1.166667)
		else
			$ELO_swing = (10 + @game.winning_score - @game.losing_score)*((@game.red_elo / @game.blue_elo)*1.166667)	
		end

		if @game.losing_score == 0
			$ELO_swing = 100
		end

		if $player1 == $player2 && $player3 == $player4
			$ELO_swing = $ELO_swing/2
		end

		if @game.winner == "Red Team"
			$player1.elo_rating += $ELO_swing
			$player2.elo_rating += $ELO_swing
			$player3.elo_rating -= $ELO_swing
			$player4.elo_rating -= $ELO_swing

			$player1.losses -= 1
			$player2.losses -= 1
			$player3.wins -= 1
			$player4.wins -= 1

			$player1.losses_on_offense -= 1
			$player2.losses_on_defense -= 1
			$player3.wins_on_offense -= 1
			$player4.wins_on_defense -= 1

			$player1.points_for -= @game.losing_score
			$player1.points_against -= @game.winning_score

			$player2.points_for -= @game.losing_score
			$player2.points_against -= @game.winning_score

			$player3.points_for -= @game.winning_score
			$player3.points_against -= @game.losing_score

			$player4.points_for -= @game.winning_score
			$player4.points_against -= @game.losing_score							
		else
			$player1.elo_rating -= $ELO_swing
			$player2.elo_rating -= $ELO_swing
			$player3.elo_rating += $ELO_swing
			$player4.elo_rating += $ELO_swing

			$player1.wins -= 1
			$player2.wins -= 1
			$player3.losses -= 1
			$player4.losses -= 1

			unless $player1 == $player2 && $player3 == $player4
				$player1.wins_on_offense -= 1
				$player2.wins_on_defense -= 1
				$player3.losses_on_offense -= 1
				$player4.losses_on_defense -= 1
			end

			$player1.points_for -= @game.winning_score
			$player1.points_against -= @game.losing_score

			$player2.points_for -= @game.winning_score
			$player2.points_against -= @game.losing_score

			$player3.points_for -= @game.losing_score
			$player3.points_against -= @game.winning_score

			$player4.points_for -= @game.losing_score
			$player4.points_against -= @game.winning_score			
		end

		@game.elo_swing = $ELO_swing
		@game.delete				

		$player1.save
		$player2.save
		$player3.save
		$player4.save			
	end

	private

	def calc_and_update_ELO

		$player1 = Player.where(:name => @game.blue_offense).first
		$player2 = Player.where(:name => @game.blue_defense).first
		$player3 = Player.where(:name => @game.red_offense).first
		$player4 = Player.where(:name => @game.red_defense).first

		@game.blue_elo = ($player1.elo_rating + $player2.elo_rating) / 2
		@game.red_elo = ($player3.elo_rating + $player4.elo_rating) / 2

		$ELO_swing = 10

		if @game.blue_elo > @game.red_elo && @game.winner == "Blue Team"
			$ELO_swing = (10 + @game.winning_score - @game.losing_score)*((@game.red_elo / @game.blue_elo)/1.166667)
		elsif @game.blue_elo > @game.red_elo && @game.winner == "Red Team"
			$ELO_swing = (10 + @game.winning_score - @game.losing_score)*((@game.blue_elo / @game.red_elo)*1.166667)
		elsif @game.blue_elo < @game.red_elo && @game.winner == "Red Team"
			$ELO_swing = (10 + @game.winning_score - @game.losing_score)*((@game.blue_elo / @game.red_elo)/1.166667)
		else
			$ELO_swing = (10 + @game.winning_score - @game.losing_score)*((@game.red_elo / @game.blue_elo)*1.166667)	
		end

		if @game.losing_score == 0
			$ELO_swing = 100
		end

		if $player1 == $player2 && $player3 == $player4
			$ELO_swing = $ELO_swing/2
		end

		if @game.winner == "Red Team"
			$player1.elo_rating -= $ELO_swing
			$player2.elo_rating -= $ELO_swing
			$player3.elo_rating += $ELO_swing
			$player4.elo_rating += $ELO_swing

			$player1.losses += 1
			$player2.losses += 1
			$player3.wins += 1
			$player4.wins += 1

			$player1.losses_on_offense += 1
			$player2.losses_on_defense += 1
			$player3.wins_on_offense += 1
			$player4.wins_on_defense += 1

			$player1.points_for += @game.losing_score
			$player1.points_against += @game.winning_score

			$player2.points_for += @game.losing_score
			$player2.points_against += @game.winning_score

			$player3.points_for += @game.winning_score
			$player3.points_against += @game.losing_score

			$player4.points_for += @game.winning_score
			$player4.points_against += @game.losing_score							
		else
			$player1.elo_rating += $ELO_swing
			$player2.elo_rating += $ELO_swing
			$player3.elo_rating -= $ELO_swing
			$player4.elo_rating -= $ELO_swing

			$player1.wins += 1
			$player2.wins += 1
			$player3.losses += 1
			$player4.losses += 1

			unless $player1 == $player2 && $player3 == $player4
				$player1.wins_on_offense += 1
				$player2.wins_on_defense += 1
				$player3.losses_on_offense += 1
				$player4.losses_on_defense += 1
			end

			$player1.points_for += @game.winning_score
			$player1.points_against += @game.losing_score

			$player2.points_for += @game.winning_score
			$player2.points_against += @game.losing_score

			$player3.points_for += @game.losing_score
			$player3.points_against += @game.winning_score

			$player4.points_for += @game.losing_score
			$player4.points_against += @game.winning_score			
		end

		@game.elo_swing = $ELO_swing
		@game.save				

		$player1.save
		$player2.save
		$player3.save
		$player4.save		
	end
end
