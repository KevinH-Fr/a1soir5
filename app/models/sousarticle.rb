class Sousarticle < ApplicationRecord
  belongs_to :article
  #validates :nature, presence: true

 # enum natures: ["retouches", "ceinture", "chaussures", 
              #  "nœud papillon", "veste", "pantalon", 
              #  "chemise", "pochette", "boutons de manchette",
              #  "gilet", "autre"]

  scope :article_courant, ->  (article_courant) { where("article_id = ?", article_courant)}
  scope :produit_courant, ->  (produit_courant) { where("sousarticles.produit_id = ?", produit_courant)}

  scope :sousarticlesLoues, -> { joins(:article).where("locvente = ?", "location")}
  scope :sousarticlesVendus, -> { joins(:article).where("locvente = ?", "vente")}


  scope :locvente, -> (locvente_value) { joins(:article).where("locvente = ?", locvente_value ) }
  
  scope :hors_devis, -> { where(article_id: Article.joins(:commande).where("devis = ?", false))}

 # scope :exclude_devis_commandes, -> {
 #   where.not(article_id: Article.joins(:commandes)
 #                               .where(commandes: { devis: false })
 #                               .pluck(:id))
 # }

 scope :a_venir, -> { joins(article: :commande).where('commandes.finloc >= ?', Date.current) }
 scope :termine, -> { joins(article: :commande).where('commandes.finloc <= ?', Date.current) }


  scope :sum_sousarticles, -> {sum('prix_sousarticle')}
  scope :sum_caution_sousarticles, -> {sum('caution_sousarticle')}
  scope :compte_sousarticles, -> {count('nature')}


    # filtres analyses
    scope :filtredatedebut, -> (debut) { where("sousarticles.created_at >= ?", debut) }
    scope :filtredatefin, -> (fin) { where("sousarticles.created_at <= ?", fin) }
     
  def texte_record
    "#{nature} | prix " "#{prix_sousarticle}" " € | description " "#{description}"
  end

 

end
