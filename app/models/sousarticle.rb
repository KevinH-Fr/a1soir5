class Sousarticle < ApplicationRecord
  belongs_to :article
  #validates :nature, presence: true

 # enum natures: ["retouches", "ceinture", "chaussures", 
              #  "nœud papillon", "veste", "pantalon", 
              #  "chemise", "pochette", "boutons de manchette",
              #  "gilet", "autre"]

  scope :article_courant, ->  (article_courant) { where("article_id = ?", article_courant)}
  scope :sum_sousarticles, -> {sum('prix_sousarticle')}
  scope :sum_caution_sousarticles, -> {sum('caution_sousarticle')}
  scope :compte_sousarticles, -> {count('nature')}

    # filtres analyses
    scope :filtredatedebut, -> (debut) { where("created_at >= ?", debut) }
    scope :filtredatefin, -> (fin) { where("created_at <= ?", fin) }
     
  def texte_record
    "#{nature} | prix " "#{prix_sousarticle}" " € | description " "#{description}"
  end

 

end
