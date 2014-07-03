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
			$ELO_swing = 50
			if @game.winner == "Blue Team"
				$player1.shutout_for += 1
				$player2.shutout_for += 1
				$player3.shutout_against += 1
				$player4.shutout_against += 1

				unless $player1 == $player2 && $player3 == $player4
					$player1.shutout_for += 1
					$player2.shutout_for += 1
					$player3.shutout_against += 1
					$player4.shutout_against += 1
				else
					$player1.shutout_for += 1
					$player3.shutout_against += 1
				end
			else
				unless $player1 == $player2 && $player3 == $player4
					$player4.shutout_for += 1
					$player3.shutout_for += 1
					$player2.shutout_against += 1
					$player1.shutout_against += 1
				else
					$player3.shutout_for += 1
					$player1.shutout_against += 1
				end
			end
		end

		if $player1 == $player2 && $player3 == $player4
			$ELO_swing = $ELO_swing/2
		end
		

		@partner1 = Partner.where(:player_id => $player1.id, :partner_id => $player2.id).first
		if @partner1 == nil
			@partner1 = Partner.create(:win_count => 0, :loss_count => 0, :win_streak => 0, :lose_streak => 0, :current_streak => 0, :player_id => $player1.id, :partner_id => $player2.id)
		end
		@partner2 = Partner.where(:player_id => $player2.id, :partner_id => $player1.id).first
		if @partner2 == nil
			@partner2 = Partner.create(:win_count => 0, :loss_count => 0, :win_streak => 0, :lose_streak => 0, :current_streak => 0, :player_id => $player2.id, :partner_id => $player1.id)
		end
		@partner3 = Partner.where(:player_id => $player3.id, :partner_id => $player4.id).first
		if @partner3 == nil
			@partner3 = Partner.create(:win_count => 0, :loss_count => 0, :win_streak => 0, :lose_streak => 0, :current_streak => 0, :player_id => $player3.id, :partner_id => $player4.id)
		end
		@partner4 = Partner.where(:player_id => $player4.id, :partner_id => $player3.id).first
		if @partner4 == nil
			@partner4 = Partner.create(:win_count => 0, :loss_count => 0, :win_streak => 0, :lose_streak => 0, :current_streak => 0, :player_id => $player4.id, :partner_id => $player3.id)
		end

		if @game.losing_score == 0
			if @game.winner == "Blue Team"
				$player1.shutout_for += 1
				$player2.shutout_for += 1
				$player3.shutout_against += 1
				$player4.shutout_against += 1

				unless $player1 == $player2 && $player3 == $player4
					$player1.shutout_for += 1
					$player3.shutout_against += 1
				end
			else
				$player4.shutout_for += 1
				$player3.shutout_for += 1
				$player2.shutout_against += 1
				$player1.shutout_against += 1

				unless $player1 == $player2 && $player3 == $player4
					$player3.shutout_for += 1
					$player1.shutout_against += 1
				end
			end
		end

		if @game.winner == "Red Team"
			$player1.elo_rating -= $ELO_swing
			$player2.elo_rating -= $ELO_swing
			$player1.overall_elo -= $ELO_swing
			$player2.overall_elo -= $ELO_swing
			$player3.elo_rating += $ELO_swing
			$player4.elo_rating += $ELO_swing
			$player3.overall_elo += $ELO_swing
			$player4.overall_elo += $ELO_swing

			if $player1.current_streak > 0
				$player1.current_streak = 0
			end
			if $player2.current_streak > 0
				$player2.current_streak = 0
			end
			if $player3.current_streak < 0
				$player3.current_streak = 0
			end
			if $player4.current_streak < 0
				$player4.current_streak = 0	
			end

			unless $player1 == $player2 && $player3 == $player4
				$player1.losses += 1
				$player2.losses += 1
				$player3.wins += 1
				$player4.wins += 1

				$player1.current_streak-=1
				$player2.current_streak-=1
				$player1.current_streak+=1
				$player2.current_streak+=1

				$player1.losses_on_offense += 1
				$player2.losses_on_defense += 1
				$player3.wins_on_offense += 1
				$player4.wins_on_defense += 1

				win_c = @partner3.win_count + 1
				current_s = @partner3.current_streak
				win_s = @partner3.win_streak 
				if current_s < 0
					current_s = 1
				else
					current_s += 1
					if current_s > win_s
						win_s = current_s
					end
				end

				@partner1.win_count = win_c
				@partner3.current_streak = current_s
				@partner3.win_streak = win_s
				@partner4.win_count = win_c
				@partner4.current_streak = current_s
				@partner4.win_streak = win_s

				current_s = @partner1.current_streak
				lose_s = @partner1.lose_streak + 1
				loss_c = @partner1.loss_count + 1

				if current_s > 0
					current_s = -1
				else
					current_s += -1
					if current_s < lose_s
						lose_s = current_s
					end
				end

				@partner1.lose_streak = lose_s
				@partner1.current_streak = current_s
				@partner1.loss_count = loss_c
				@partner2.lose_streak = lose_s
				@partner2.current_streak = current_s
				@partner2.loss_count = loss_c
			else
				$player1.losses += 1
				$player3.wins += 1

				$player1.current_streak-=1
				$player3.current_streak+=1
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

			if $player1.current_streak < 0
				$player1.current_streak = 0
			end
			if $player2.current_streak < 0
				$player2.current_streak = 0
			end
			if $player3.current_streak > 0
				$player3.current_streak = 0
			end
			if $player4.current_streak > 0
				$player4.current_streak = 0
			end

			unless $player1 == $player2 && $player3 == $player4
				$player1.wins += 1
				$player2.wins += 1
				$player3.losses += 1
				$player4.losses += 1
				
				$player1.current_streak-=1
				$player2.current_streak-=1
				$player1.current_streak+=1
				$player2.current_streak+=1

				$player1.win_streak += 1
				$player1.loss_streak = 0
				$player2.win_streak += 1
				$player2.loss_streak = 0
				$player3.win_streak = 0
				$player3.loss_streak  += 1
				$player4.win_streak = 0
				$player4.loss_streak += 1

				$player1.wins_on_offense += 1
				$player2.wins_on_defense += 1
				$player3.losses_on_offense += 1
				$player4.losses_on_defense += 1
				#player1/player2 win.


				win_c = @partner1.win_count + 1
				current_s = @partner1.current_streak
				win_s = @partner1.win_streak 
				if current_s < 0
					current_s = 1
				else
					current_s += 1
					if current_s > win_s
						win_s = current_s
					end
				end

				@partner1.win_count = win_c
				@partner1.current_streak = current_s
				@partner1.win_streak = win_s
				@partner2.win_count = win_c
				@partner2.current_streak = current_s
				@partner2.win_streak = win_s

				current_s = @partner3.current_streak
				lose_s = @partner3.lose_streak
				loss_c = @partner3.loss_count + 1

				if current_s > 0
					current_s = -1
				else
					current_s += -1
					if current_s < lose_s
						lose_s = current_s
					end
				end

				@partner3.lose_streak = lose_s
				@partner3.current_streak = current_s
				@partner3.loss_count = loss_c
				@partner4.lose_streak = lose_s
				@partner4.current_streak = current_s
				@partner4.loss_count = loss_c
			else
				$player1.wins += 1
				$player3.losses += 1
				
				$player1.current_streak+=1
				$player3.current_streak-=1
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

		if $player1.current_streak < $player1.win_streak
			$player1.win_streak = $player1.current_streak
		end
		if $player1.current_streak * -1 < $player1.loss_streak
			$player1.loss_streak = $player1.current_streak
		end
		if $player2.current_streak < $player2.win_streak
			$player2.win_streak = $player2.current_streak
		end
		if $player2.current_streak * -1 < $player2.loss_streak
			$player2.loss_streak = $player2.current_streak
		end

		if $player3.current_streak < $player3.win_streak
			$player3.win_streak = $player3.current_streak
		end
		if $player3.current_streak * -1 < $player3.loss_streak
			$player3.loss_streak = $player3.current_streak
		end

		if $player4.current_streak < $player4.win_streak
			$player4.win_streak = $player4.current_streak
		end
		if $player4.current_streak * -1 < $player4.loss_streak
			$player4.loss_streak = $player4.current_streak
		end
		
		@game.elo_swing = $ELO_swing
		@game.save				

		$player1.save
		$player2.save
		$player3.save
		$player4.save

		@partner1.save
		@partner2.save
		@partner3.save
		@partner4.save

		$player1ELO.save
		$player2ELO.save
		$player3ELO.save
		$player4ELO.save
	end

end
