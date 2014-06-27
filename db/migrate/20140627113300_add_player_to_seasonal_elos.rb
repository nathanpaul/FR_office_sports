class AddPlayerToSeasonalElos < ActiveRecord::Migration
  def change
  	add_column :seasonal_elos, :player, :integer, index: true
  end
end
