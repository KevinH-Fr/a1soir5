class AddCommentairedocToMessagemails < ActiveRecord::Migration[7.0]
  def change
    add_column :messagemails, :commentairedoc, :text
  end
end
