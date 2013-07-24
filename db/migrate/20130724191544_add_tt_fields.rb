class AddTtFields < ActiveRecord::Migration
  def change
  	add_column :tt_games, :player_one, :string
  	add_column :tt_games, :player_two, :string
  	add_column :tt_games, :winning_score, :integer
  	add_column :tt_games, :losing_score, :integer
  	add_column :tt_games, :winner, :string
  	add_column :tt_games, :elo_swing, :float
  	add_column :tt_players, :wins, :integer
  	add_column :tt_players, :losses, :integer
  	add_column :tt_players, :elo_rating, :float
  	add_column :tt_players, :name, :string
  	add_column :tt_players, :games_for, :integer
  	add_column :tt_players, :games_against, :integer
  	add_column :tt_players, :position, :integer
  end
end
