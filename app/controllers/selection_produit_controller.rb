class SelectionProduitController < ApplicationController
  before_action :authenticate_user!
  
    def index

        @commandeId = params[:commandeId] 

        @articleId = params[:articleId] 
   
        @clientId = Commande.find(@commandeId).client_id

        @categories = Produit.categories.keys 
        @couleurs = Produit.couleurs.keys 

        search_params = params.permit(:format, :page, 
            q:[:nom_or_reffrs_or_categorie_or_couleur_cont])
            @q = Produit.ransack(search_params[:q])
            produits = @q.result(distinct: true).order(created_at: :desc)
            @pagy, @produits = pagy_countless(produits, items: 8)
          

           categorieVal = params[:categorieVal]
           couleurVal = params[:couleurVal]
       
           if categorieVal.present?
             @produits = Produit.categorie_selected(categorieVal)
             @couleurs = Produit.categorie_selected(categorieVal).distinct.pluck(:couleur)
               if couleurVal.present?
                 @produits = Produit.categorie_selected(categorieVal).couleur_selected(couleurVal)
               end
           else
           # @produits = Produit.all 
           end
          
         # @categories = Produit.categories.keys
       
           qVal = params[:q]
           if qVal.present?
             @q = Produit.ransack(params[:q])
             @produits = @q.result(distinct: true)
           end 

  
     end
  
    def scanqr
        @commandeId = params[:commandeId]
        @articleId = params[:articleId] 
    end 

end
  