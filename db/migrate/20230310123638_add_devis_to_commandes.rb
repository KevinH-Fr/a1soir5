class AddDevisToCommandes < ActiveRecord::Migration[7.0]
  def change
    add_column :commandes, :devis, :boolean
  end
end
