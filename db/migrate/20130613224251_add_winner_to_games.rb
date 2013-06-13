class AddWinnerToGames < ActiveRecord::Migration
  def change
    add_column :games, :winner, :string
    add_column :games, :player_id, :integer
  end
end
