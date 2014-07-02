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
		seasonID = Season.where(:active => 1)

		redO = Player.find(Game.last.red_offense)
		redD = Player.find(Game.last.red_defense)
		blueO = Player.find(Game.last.blue_offense)
		blueD = Player.find(Game.last.blue_defense)
		redO_se = SeasonalELO.where(:player_id => redO.id, :season => seasonID).first
		redD_se = SeasonalELO.where(:player_id => redD.id, :season => seasonID).first
		blueO_se = SeasonalELO.where(:player_id => blueO.id, :season => seasonID).first
		blueD_se = SeasonalELO.where(:player_id => blueD.id, :season => seasonID).first

		swing = Game.last.elo_swing

		if $last_game.winner == "Red Team" and $last_game.red_offense != $last_game.red_defense
			redO.wins -= 1
			redO.wins_on_offense -= 1
			redO.overall_elo -= swing
			redO.points_for -= Game.last.winning_score
			redO.points_against -= Game.last.losing_score
			redO_se.elo -= swing

			redD.wins -= 1
			redD.wins_on_defense -= 1
			redD.overall_elo -= swing
			redD.points_for -= Game.last.winning_score
			redD.points_against -= Game.last.losing_score
			redD_se.elo -= swing

			blueO.losses -= 1
			blueO.losses_on_offense -= 1
			blueO.overall_elo += swing
			blueO.points_for -= Game.last.losing_score
			blueO.points_against -= Game.last.winning_score
			blueO_se.elo += swing

			blueD.losses -= 1
			blueD.losses_on_defense -= 1
			blueD.overall_elo += swing
			blueD.points_for -= Game.last.losing_score
			blueD.points_against -= Game.last.winning_score
			blueD_se.elo += swing

			redO.save
			redD.save
			blueO.save
			blueD.save
			redO_se.save
			redD_se.save
			blueO_se.save
			blueD_se.save

		elsif $last_game.winner == "Blue Team" and $last_game.blue_offense != $last_game.blue_defense
			blueO.wins -= 1
			blueO.wins_on_offense -= 1
			blueO.overall_elo -= swing
			blueO.points_for -= Game.last.winning_score
			blueO.points_against -= Game.last.losing_score
			blueO_se.elo -= swing

			blueD.wins -= 1
			blueD.wins_on_defense -= 1
			blueD.overall_elo -= swing
			blueD.points_for -= Game.last.winning_score
			blueD.points_against -= Game.last.losing_score
			blueD_se.elo -= swing

			redO.losses -= 1
			redO.losses_on_offense -= 1
			redO.overall_elo += swing
			redO.points_for -= Game.last.losing_score
			redO.points_against -= Game.last.winning_score
			redO_se.elo += swing

			redD.losses -= 1
			redD.losses_on_defense -= 1
			redD.overall_elo += swing
			redD.points_for -= Game.last.losing_score
			redD.points_against -= Game.last.winning_score
			redD_se.elo += swing

			redO.save
			redD.save
			blueO.save
			blueD.save
			redO_se.save
			redD_se.save
			blueO_se.save
			blueD_se.save

		elsif $last_game.winner == "Red Team" and $last_game.red_offense == $last_game.red_defense
			redO.wins -= 1
			redO.overall_elo -= swing
			redO.points_for -= Game.last.winning_score
			redO.points_against -= Game.last.losing_score
			redO_se.elo -= swing

			blueO.losses -= 1
			blueO.overall_elo += swing
			blueO.points_for -= Game.last.losing_score
			blueO.points_against -= Game.last.winning_score
			blueO_se.elo += swing

			redO.save
			blueO.save
			redO_se.save
			blueO_se.save

		else
			blueO.wins -= 1
			blueO.overall_elo -= swing
			blueO.points_for -= Game.last.winning_score
			blueO.points_against -= Game.last.losing_score
			blueO_se.elo -= swing

			redO.losses -= 1
			redO.overall_elo += swing
			redO.points_for -= Game.last.losing_score
			redO.points_against -= Game.last.winning_score
			redO_se.elo += swing

			redO.save
			blueO.save
			redO_se.save
			blueO_se.save
		end

		Game.last.delete
		redirect_to root_path
	end	

	private

	def calc_and_update_ELO
		@seasonID = Season.where(:active => 1).first.id

		$player1 = Player.find(@game.blue_offense)
		$player1ELO = SeasonalELO.where(:player_id => $player1.id, :season => @seasonID).first
		if $player1ELO == nil
			$player1ELO = SeasonalELO.create(:player_id => $player1.id, :season => @seasonID, :elo => 1500)
		end

		$player2 = Player.find(@game.blue_defense)
		$player2ELO = SeasonalELO.where(:player_id => $player2.id, :season => @seasonID).first
		if $player2ELO == nil
			$player2ELO = SeasonalELO.create(:player_id => $player2.id, :season => @seasonID, :elo => 1500)
		end

		$player3 = Player.find(@game.red_offense)
		$player3ELO = SeasonalELO.where(:player_id => $player3.id, :season => @seasonID).first
		if $player3ELO == nil
			$player3ELO = SeasonalELO.create(:player_id => $player3.id, :season => @seasonID, :elo => 1500)
		end

		$player4 = Player.find(@game.red_defense)
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
