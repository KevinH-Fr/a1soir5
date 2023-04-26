class AddCommentaireToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :commentaire, :text
  end
end
