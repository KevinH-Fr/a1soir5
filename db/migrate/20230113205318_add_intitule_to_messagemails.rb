class AddIntituleToMessagemails < ActiveRecord::Migration[7.0]
  def change
    add_column :messagemails, :intitule, :string
  end
end
