class Fournisseur < ApplicationRecord
    has_many :produits

    validates :nom, presence: true

    scope :fournisseur_courant, ->  (fournisseur_courant) { where("id = ?", fournisseur_courant)}

end
