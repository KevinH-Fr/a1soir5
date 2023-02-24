class AddTypedocToMessagemails < ActiveRecord::Migration[7.0]
  def change
    add_column :messagemails, :typedoc, :string
  end
end
