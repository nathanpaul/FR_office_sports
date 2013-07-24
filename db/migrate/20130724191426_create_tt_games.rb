class CreateTtGames < ActiveRecord::Migration
  def change
    create_table :tt_games do |t|

      t.timestamps
    end
  end
end
