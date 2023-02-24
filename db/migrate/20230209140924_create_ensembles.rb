class CreateEnsembles < ActiveRecord::Migration[7.0]
  def change
    create_table :ensembles do |t|
      t.string :articleparent
      t.string :categorieenfant

      t.timestamps
    end
  end
end
