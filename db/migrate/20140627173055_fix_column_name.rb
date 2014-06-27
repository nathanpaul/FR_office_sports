class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :seasonal_elos, :player, :player_id
  end
end
