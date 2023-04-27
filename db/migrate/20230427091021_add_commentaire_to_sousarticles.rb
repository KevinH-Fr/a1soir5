class AddCommentaireToSousarticles < ActiveRecord::Migration[7.0]
  def change
    add_column :sousarticles, :commentaire, :text
  end
end
