class AddActiveToPlayers < ActiveRecord::Migration
  def change
  	add_column :players, :active, :integer
  end
end
