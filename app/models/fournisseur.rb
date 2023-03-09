class Fournisseur < ApplicationRecord
    has_many :produits

    validates :nom, presence: true

   

end
