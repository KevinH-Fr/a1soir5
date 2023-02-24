class AddCommentairefasimpleToMessagemails < ActiveRecord::Migration[7.0]
  def change
    add_column :messagemails, :commentairefasimple, :text
  end
end
