class FixCapsAgaon < ActiveRecord::Migration
  def change
  	rename_column :games, :blue_ELO, :blue_elo
  	rename_column :games, :red_ELO, :red_elo
  end
end
