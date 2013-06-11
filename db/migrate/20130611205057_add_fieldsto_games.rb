class AddFieldstoGames < ActiveRecord::Migration
  def change
  	add_column :games, :winning_score, :integer
  	add_column :games, :losing_score, :integer
  	add_column :games, :blue_offense, :string
  	add_column :games, :blue_defense, :string
  	add_column :games, :red_offense, :string
  	add_column :games, :red_defense, :string
  	add_column :games, :blue_ELO, :float
  	add_column :games, :red_ELO, :float
  	add_column :players, :points_for, :integer
  	add_column :players, :points_against, :integer
  end
end
