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
			$ELO_swing = 50
		end

		if $player1 == $player2 && $player3 == $player4
			$ELO_swing = $ELO_swing/2
		end
		

		@partner1 = Partner.where(:player_id => $player1.id, :partner_id => $player2.id).first
		if @partner1 == nil
			puts 'hi'
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

		if @game.winner == "Red Team"
			$player1.elo_rating -= $ELO_swing
			$player2.elo_rating -= $ELO_swing
			$player1.overall_elo -= $ELO_swing
			$player2.overall_elo -= $ELO_swing
			$player3.elo_rating += $ELO_swing
			$player4.elo_rating += $ELO_swing
			$player3.overall_elo += $ELO_swing
			$player4.overall_elo += $ELO_swing
			#player3, player 4 win.

			unless $player1 == $player2 && $player3 == $player4
				$player1.losses += 1
				$player2.losses += 1
				$player3.wins += 1
				$player4.wins += 1

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

				$player1.win_streak = 0
				$player1.loss_streak+=1
				$player3.win_streak+=1
				$player3.loss_streak = 0
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

				$player1.win_streak += 1
				$player1.loss_streak = 0
				$player3.win_streak = 0
				$player3.loss_streak  += 1
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
