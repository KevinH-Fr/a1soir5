class AddEditmailToMessagemails < ActiveRecord::Migration[7.0]
  def change
    add_column :messagemails, :editmail, :boolean
  end
end
