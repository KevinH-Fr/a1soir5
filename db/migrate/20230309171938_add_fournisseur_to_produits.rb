class AddFournisseurToProduits < ActiveRecord::Migration[7.0]
  def change
    add_reference :produits, :fournisseur, null: true, foreign_key: true
  end
end
