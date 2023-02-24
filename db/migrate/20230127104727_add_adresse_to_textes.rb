class AddAdresseToTextes < ActiveRecord::Migration[7.0]
  def change
    add_column :textes, :adresse, :text
  end
end
