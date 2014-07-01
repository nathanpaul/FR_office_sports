class AddShutoutForToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :shutout_for, :integer
  end
end
