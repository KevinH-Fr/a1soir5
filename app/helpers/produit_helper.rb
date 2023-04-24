module ProduitHelper

    def produitsIdentiques 
    
        Produit.where.not(taille: @produit.taille)
        .where(reffrs: @produit.reffrs, couleur: @produit.couleur)
        .where.not(reffrs: [nil, ""])
 
    end 

    def existanceAutresTailles()
        if self.produitsIdentiques.present?
            true
        else
            false
        end
    end 

    def taillesAutresProduits()
        if  self.existanceAutresTailles == true 
            self.produitsIdentiques
        end
    end 

    def prixProduit(produit_id)
       # produit = Produit.find(produit_id)
       # @produit.prix
    end

    def prixLocationProduit(produit_id)
       # produit = Produit.find(produit_id)
       # produit.prixlocation
    end

    def prixCautionProduit(produit_id)
       # produit = Produit.find(produit_id)
       # produit.caution
    end
      
end