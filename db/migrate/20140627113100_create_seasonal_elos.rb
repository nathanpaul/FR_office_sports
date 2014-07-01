class CreateSeasonalElos < ActiveRecord::Migration
  def change
    create_table :seasonal_elos do |t|

      t.timestamps
    end
  end
end
