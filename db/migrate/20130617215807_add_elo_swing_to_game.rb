class AddEloSwingToGame < ActiveRecord::Migration
  def change
    add_column :games, :ELO_swing, :float
  end
end
