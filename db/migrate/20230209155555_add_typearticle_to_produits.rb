class AddTypearticleToProduits < ActiveRecord::Migration[7.0]
  def change
    add_column :produits, :typearticle, :string
  end
end
