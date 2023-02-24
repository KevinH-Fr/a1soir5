class AddContentToProduits < ActiveRecord::Migration[7.0]
  def change
    add_column :produits, :nomfrs, :string
    add_column :produits, :dateachat, :datetime
    add_column :produits, :prixachat, :decimal
  end
end
