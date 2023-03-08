class AccueilAdminController < ApplicationController
  
  before_action :authenticate_user!

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
   end

  def analyses 
    datedebut = DateTime.parse(params[:debut]) if params[:debut].present?
    datefin = DateTime.parse(params[:fin]) if params[:fin].present?

    if datedebut.present? && datefin.present? 
      @nbTotal = Commande.filtredatedebut(datedebut).filtredatefin(datefin).count
      @nbRetire = Commande.filtredatedebut(datedebut).filtredatefin(datefin).retire.count 
      @nbNonRetire = Commande.filtredatedebut(datedebut).filtredatefin(datefin).non_retire.count 
      @nbRendu = Commande.filtredatedebut(datedebut).filtredatefin(datefin).rendu.count 
   
      @groupedByDate = Commande.filtredatedebut(datedebut).filtredatefin(datefin).group('DATE(created_at)').count('created_at')

    else
      @nbTotal = Commande.count
      @nbRetire = Commande.retire.count 
      @nbNonRetire = Commande.non_retire.count 
      @nbRendu = Commande.rendu.count 
    end 
        
  end 
  
end
  