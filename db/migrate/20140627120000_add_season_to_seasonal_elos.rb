class AddSeasonToSeasonalElos < ActiveRecord::Migration
  def change
    add_column :seasonal_elos, :season, :integer, index: true
  end
end