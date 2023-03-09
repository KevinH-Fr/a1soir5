class CreateFournisseurs < ActiveRecord::Migration[7.0]
  def change
    create_table :fournisseurs do |t|
      t.string :nom
      t.string :pays
      t.string :telephone
      t.string :mail
      t.string :representant
      t.text :notes

      t.timestamps
    end
  end
end
