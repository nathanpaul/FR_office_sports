class FixEloCaps < ActiveRecord::Migration
  def up
    rename_column :games, :blue_ELO, :blue_elo
    rename_column :games, :red_ELO, :red_elo
    rename_column :games, :ELO_swing, :elo_swing
    rename_column :players, :ELO_rating, :elo_rating
  end

  def down
    rename_column :games, :blue_elo, :blue_ELO
    rename_column :games, :red_elo, :red_ELO
    rename_column :games, :elo_swing, :ELO_swing
    rename_column :players, :elo_raing, :ELO_rating
  end
end
