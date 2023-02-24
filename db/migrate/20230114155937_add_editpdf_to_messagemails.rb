class AddEditpdfToMessagemails < ActiveRecord::Migration[7.0]
  def change
    add_column :messagemails, :editpdf, :boolean
  end
end
