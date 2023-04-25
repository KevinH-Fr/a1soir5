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

      
end