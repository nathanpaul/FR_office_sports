class AddLossStreakToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :loss_streak, :integer
  end
end
