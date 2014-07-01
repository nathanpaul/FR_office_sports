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

	def random_game
		respond_to do |format|
			format.html
		end
	end

	def delete_last_game
		Game.remove_last_game
		redirect_to root_path
	end	

	private

	def calc_and_update_ELO
		@seasonID = Season.where(:active => 1).first.id

		$player1 = Player.where(:name => @game.blue_offense).first
		$player1ELO = SeasonalELO.where(:player_id => $player1.id, :season => @seasonID).first
		if $player1ELO == nil
			$player1ELO = SeasonalELO.create(:player_id => $player1.id, :season => @seasonID, :elo => 1500)
			puts "--OH SHITE--"
		end

		$player2 = Player.where(:name => @game.blue_defense).first
		$player2ELO = SeasonalELO.where(:player_id => $player2.id, :season => @seasonID).first
		if $player2ELO == nil
			$player2ELO = SeasonalELO.create(:player_id => $player2.id, :season => @seasonID, :elo => 1500)
		end

		$player3 = Player.where(:name => @game.red_offense).first
		$player3ELO = SeasonalELO.where(:player_id => $player3.id, :season => @seasonID).first
		if $player3ELO == nil
			$player3ELO = SeasonalELO.create(:player_id => $player3.id, :season => @seasonID, :elo => 1500)
		end

		$player4 = Player.where(:name => @game.red_defense).first
		$player4ELO = SeasonalELO.where(:player_id => $player4.id, :season => @seasonID).first
		if $player4ELO == nil
			$player4ELO = SeasonalELO.create(:player_id => $player4.id, :season => @seasonID, :elo => 1500)
		end	

		@game.blue_elo = ($player1ELO.elo + $player2ELO.elo) / 2
		@game.red_elo = ($player3ELO.elo + $player4ELO.elo) / 2

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
			$player1ELO.elo -= $ELO_swing
			$player2ELO.elo -= $ELO_swing
			$player1.overall_elo -= $ELO_swing
			$player2.overall_elo -= $ELO_swing			
			$player3ELO.elo += $ELO_swing
			$player4ELO.elo += $ELO_swing
			$player3.overall_elo += $ELO_swing
			$player4.overall_elo += $ELO_swing			

			unless $player1 == $player2 && $player3 == $player4
				$player1.losses += 1
				$player2.losses += 1
				$player3.wins += 1
				$player4.wins += 1

				$player1.losses_on_offense += 1
				$player2.losses_on_defense += 1
				$player3.wins_on_offense += 1
				$player4.wins_on_defense += 1
			else
				$player1.losses += 1
				$player3.wins += 1
			end

			$player1.points_for += @game.losing_score
			$player1.points_against += @game.winning_score

			$player2.points_for += @game.losing_score
			$player2.points_against += @game.winning_score

			$player3.points_for += @game.winning_score
			$player3.points_against += @game.losing_score

			$player4.points_for += @game.winning_score
			$player4.points_against += @game.losing_score							
		else
			$player1ELO.elo += $ELO_swing
			$player2ELO.elo += $ELO_swing
			$player1.overall_elo += $ELO_swing
			$player2.overall_elo += $ELO_swing
			$player3ELO.elo -= $ELO_swing
			$player4ELO.elo -= $ELO_swing
			$player3.overall_elo -= $ELO_swing
			$player4.overall_elo -= $ELO_swing

			unless $player1 == $player2 && $player3 == $player4
				$player1.wins += 1
				$player2.wins += 1
				$player3.losses += 1
				$player4.losses += 1

				$player1.wins_on_offense += 1
				$player2.wins_on_defense += 1
				$player3.losses_on_offense += 1
				$player4.losses_on_defense += 1
			else
				$player1.wins += 1
				$player3.losses += 1
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

		$player1ELO.save
		$player2ELO.save
		$player3ELO.save
		$player4ELO.save
	end

end
