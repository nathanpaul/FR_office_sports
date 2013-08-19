class Game < ActiveRecord::Base
	belongs_to :player
	attr_accessible :remember_token, :winning_score, :losing_score, :blue_offense, :blue_defense, :red_offense, :red_defense, :blue_elo, :red_elo, :winner, :elo_swing, :password

	def self.remove_last_game
		last_game = Game.last
		if last_game.winner == "Red Team"
			winner_one = Player.where(:name => last_game.red_offense).first
			winner_two = Player.where(:name => last_game.red_defense).first
			loser_one = Player.where(:name => last_game.blue_offense).first
			loser_two = Player.where(:name => last_game.blue_defense).first
		else
			loser_one = Player.where(:name => last_game.red_offense).first
			loser_two = Player.where(:name => last_game.red_defense).first
			winner_one = Player.where(:name => last_game.blue_offense).first
			winner_two = Player.where(:name => last_game.blue_defense).first
		end

		if winner_one and winner_two and loser_one and loser_two
			if winner_one != winner_two
				winner_one.elo_rating -= last_game.elo_swing
				winner_two.elo_rating -= last_game.elo_swing
				loser_one.elo_rating += last_game.elo_swing
				loser_two.elo_rating += last_game.elo_swing

				winner_one.points_for -= last_game.winning_score
				winner_one.points_against -= last_game.losing_score
				winner_two.points_for -= last_game.winning_score
				winner_two.points_against -= last_game.losing_score
				loser_one.points_for -= last_game.losing_score
				loser_one.points_against -= last_game.winning_score
				loser_two.points_for -= last_game.losing_score
				loser_two.points_against -= last_game.winning_score

				winner_one.wins_on_offense -= 1
				winner_two.wins_on_defense -= 1
				loser_one.losses_on_offense -= 1
				loser_two.losses_on_defense -= 1

				winner_one.wins -= 1
				winner_two.wins -= 1
				loser_one.losses -= 1
				loser_two.losses -= 1

				winner_one.save!
				winner_two.save!
				loser_one.save!
				loser_two.save!

				Game.last.delete
			else
				winner_one.elo_rating -= last_game.elo_swing
				loser_one.elo_rating += last_game.elo_swing

				winner_one.points_for -= last_game.winning_score
				winner_one.points_against -= last_game.losing_score
				loser_one.points_for -= last_game.losing_score
				loser_one.points_against -= last_game.winning_score

				winner_one.wins -= 1
				loser_one.losses -= 1

				winner_one.save!
				loser_one.save!

				Game.last.delete
			end
		end
	end
end
