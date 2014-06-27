class AddEloToSeasonalElos < ActiveRecord::Migration
  def change
    add_column :seasonal_elos, :elo, :integer
  end
end
