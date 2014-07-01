class AddKeysToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :player_id, :integer, index: true
    add_column :partners, :partner_id, :integer, index: true
  end
end
