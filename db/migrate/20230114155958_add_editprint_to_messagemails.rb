class AddEditprintToMessagemails < ActiveRecord::Migration[7.0]
  def change
    add_column :messagemails, :editprint, :boolean
  end
end
