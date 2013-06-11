class AddWinstoPlayer < ActiveRecord::Migration
  def change
  	add_column :players, :wins, :integer
  	add_column :players, :losses, :integer
  	add_column :players, :wins_on_offense, :integer
  	add_column :players, :losses_on_offense, :integer
  	add_column :players, :wins_on_defense, :integer
  	add_column :players, :losses_on_defense, :integer
  	add_column :players, :ELO_rating, :float
  end
end
