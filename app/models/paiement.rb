class Paiement < ApplicationRecord
  belongs_to :commande, :optional => true

  enum typePaiements: ["Prix", "Caution"]
  enum moyenPaiements: ["CB", "Espèces", "Virement", "Chèque"]

  scope :commande_courante, ->  (commande_courante) { where("commande_id = ?", commande_courante)}
  
  scope :prix_only, -> { where("typepaiement = ?", "Prix")}
  scope :caution_only, -> { where("typepaiement = ?", "Caution")}

  scope :sum_paiements, -> {sum('montant')}
  scope :compte_paiements, -> {count('montant')}

  # filtres analyses
  # attention date sur created_at, pas de date de réglement
  scope :filtredatedebut, -> (debut) { where("created_at >= ?", debut) }
  scope :filtredatefin, -> (fin) { where("created_at <= ?", fin) }
  
  
  def format_date
    datetime = created_at.to_date
    created_at.strftime("%d/%m/%y")
  end 

  #def texte_record
  #  datetime = created_at.to_date
  #   "#{typepaiement}" " reçu le " "#{created_at.strftime("%d/%m/%y")}"
  #end 

end


