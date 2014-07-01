class AddColumnsToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :win_count, :integer
    add_column :partners, :loss_count, :integer
    add_column :partners, :win_streak, :integer
    add_column :partners, :lose_streak, :integer
    add_column :partners, :current_streak, :integer
  end
end
