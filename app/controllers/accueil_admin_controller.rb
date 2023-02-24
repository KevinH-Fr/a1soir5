class AccueilAdminController < ApplicationController

    def index
      @clients = Client.all
      @client = Client.new
      @produits = Produit.all
      @commandes = Commande.all
      
      @meetings = Meeting.all
    end

    def stock
      @pagy, @produits = pagy(Produit.order(created_at: :desc), items: 5)
    end 

    
    def details_produit
      @produit = params[:produitId]
      #redirect_to root_path()
   end
  
  end
  