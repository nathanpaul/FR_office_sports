class AddCurrentStreakToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :current_streak, :integer
  end
end
