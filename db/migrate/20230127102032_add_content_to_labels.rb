class AddContentToLabels < ActiveRecord::Migration[7.0]
  def change
    add_column :labels, :info, :text
    add_column :labels, :boutique, :text
  end
end
