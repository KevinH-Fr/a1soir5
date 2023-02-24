class Messagemail < ApplicationRecord
  belongs_to :commande, :optional => true
  belongs_to :client, :optional => true

  has_rich_text :bodymail

  enum typedocs: ["commande", "facture", "facture simple"]


end
