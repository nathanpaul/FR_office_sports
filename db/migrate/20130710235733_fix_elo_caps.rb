class FixEloCaps < ActiveRecord::Migration
  def change
  	rename_column :players, :ELO_rating, :elo_rating
  	rename_column :games, :ELO_swing, :elo_swing
  end
end
