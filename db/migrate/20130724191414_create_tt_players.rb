class CreateTtPlayers < ActiveRecord::Migration
  def change
    create_table :tt_players do |t|

      t.timestamps
    end
  end
end
