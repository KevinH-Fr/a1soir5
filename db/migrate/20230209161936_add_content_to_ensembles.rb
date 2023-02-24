class AddContentToEnsembles < ActiveRecord::Migration[7.0]
  def change
    add_column :ensembles, :categorieenfant2, :string
    add_column :ensembles, :categorieenfant3, :string
    add_column :ensembles, :categorieenfant4, :string
    add_column :ensembles, :categorieenfant5, :string
    add_column :ensembles, :categorieenfant6, :string
  end
end
