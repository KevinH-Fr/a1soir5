class Texte < ApplicationRecord
    has_rich_text :content
    has_rich_text :contact
    has_rich_text :horaire
    has_rich_text :boutique
    has_rich_text :adresse
end
