class AddOverallElOtoPlayers < ActiveRecord::Migration
  def change
  	add_column :players, :overall_elo, :float
  end
end
