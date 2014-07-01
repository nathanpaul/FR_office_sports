class ChangeDataTypeForSeasonalElo < ActiveRecord::Migration
  def change
  	change_table :seasonal_elos do |t|
  		t.change :elo, :float
  	end
  end
end
