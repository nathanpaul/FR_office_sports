class AddShutoutAgainstToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :shutout_against, :integer
  end
end
