class AddProduitToSousarticles < ActiveRecord::Migration[7.0]
  def change
    add_reference :sousarticles, :produit, null: true, foreign_key: true
  end
end
