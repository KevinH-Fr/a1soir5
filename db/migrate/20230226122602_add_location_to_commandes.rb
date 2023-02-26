class AddLocationToCommandes < ActiveRecord::Migration[7.0]
  def change
    add_column :commandes, :location, :boolean
  end
end
