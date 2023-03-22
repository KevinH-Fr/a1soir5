class Produit < ApplicationRecord

   # has_many :ensembles
    #has_one_attached :image1

    has_one_attached :image1
    has_many_attached :images

    validates :image1, presence: false, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'video/mp4'], size_range: 1..(10.megabytes) }
    validates :images, presence: false, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'video/mp4'], size_range: 1..(50.megabytes) }


   # belongs_to :fournisseur

    has_one_attached :qr_code

    after_create :generate_qr

    def generate_qr
        GenerateQr.call(self)
      
    end
    
    enum categories: ["Robes de soirées", "Robes de mariées", "Costumes hommes", "Accessoires", "Costumes et déguisements"]
    enum typearticles: ["Ensemble", "Robe", "Veste", "Pantalon", "Chemise", "Noeud papillon", "Ceinture", "Chaussures", "Boutons"]
    enum couleurs: ["Bleu", "Blanc", "Rouge"]
    enum tailles: ["S", "M", "L"]

    scope :showed_vitrine, -> { where("vitrine = ?", true) }
    scope :showed_eshop, -> { where("eshop = ?", true) }
    
    scope :compte_produits, -> {sum('quantite')}

    scope :categorie_robes_soirees, -> { where("categorie = ?", "Robes de soirées") } # categorie 1
    scope :categorie_robes_mariees, -> { where("categorie = ?", "Robes de mariées") }
    scope :categorie_costumes_hommes, -> { where("categorie = ?", "Costumes hommes") }
    scope :categorie_accessoires, -> { where("categorie = ?", "Accessoires") }
    scope :categorie_costumes_deguisements, -> { where("categorie = ?", "Costumes et déguisements") }

    scope :type_ensemble, -> { where("typearticle = ?", "Ensemble") }

    # articles dont typearticle existe et pas Ensemble
   # scope :typearticle_exists, -> { where.not("typearticle = ?", "[nil, ""]"). where.not("typearticle = ?", "Ensemble") }
   scope :typearticle_exists, -> { where.not(typearticle: [nil, "", "Ensemble"]).pluck(:typearticle).uniq }

   
    scope :categorie_selected, ->  (categorieVal) { where("categorie = ?", categorieVal)}
    scope :couleur_selected, ->  (couleurVal) { where("couleur = ?", couleurVal)}
    scope :taille_selected, ->  (tailleVal) { where("taille = ?", tailleVal)}

    scope :fournisseur_courant, ->  (fournisseur_courant) { where("fournisseur_id = ?", fournisseur_courant)}
    scope :compte_produits, -> {sum('quantite')}

    # filtres analyses
    scope :filtredatedebut, -> (debut) { where("dateachat >= ?", debut) }
    scope :filtredatefin, -> (fin) { where("dateachat <= ?", fin) }
        
    def full_name
        "n°#{id} | #{nom} "
    end

    def full_details
        {
            id: id,
            nom: nom,
            description: description,
            image: image1
        }
    end

    def nom_couleur_taille 
        "#{nom} | #{couleur} | #{taille}"
    end 

    def nom_ref_couleur_taille 
        "#{nom} | #{reffrs} | #{couleur} | #{taille}"
    end 

    def default_image
        if image1.attached?
          image1
        else
          'no_photo.png'
        end
    end
      

    def statut_vitrine
        if self.vitrine == true
            "vrai_icon.png"
        else
            "false_icon.png"
        end 
    end



end

