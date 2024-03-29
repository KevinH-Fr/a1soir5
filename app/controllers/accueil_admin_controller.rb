class AccueilAdminController < ApplicationController
  
  before_action :authenticate_user!
  before_action :authenticate_vendeur_or_admin!

    def index
      @clients = Client.all
      @client = Client.new
      @produits = Produit.all
      @commandes = Commande.all
      @meetings = Meeting.all

      # gestion dates pour liens vers produits
      first_day = Date.current.beginning_of_month
      last_day = Date.current.end_of_month
    
      if params[:debut].present?
        @datedebut = DateTime.parse(params[:debut])
      else
        @datedebut = first_day
      end
  
      if params[:fin].present?
        @datefin = DateTime.parse(params[:fin]) 
      else
        @datefin = last_day
      end

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
    @datedebut = DateTime.parse(params[:debut]) if params[:debut].present?
    @datefin = DateTime.parse(params[:fin]) if params[:fin].present?


    if datedebut.present? && datefin.present? 
      @commandesFiltres = Commande.hors_devis.filtredatedebut(datedebut).filtredatefin(datefin)
      @articlesFiltres = Article.joins(:commande).merge(Commande.hors_devis).filtredatedebut(datedebut).filtredatefin(datefin)
      @sousArticlesFiltres = Sousarticle.filtredatedebut(datedebut).filtredatefin(datefin)
      @paiementsFiltres = Paiement.filtredatedebut(datedebut).filtredatefin(datefin)
    else
      @commandesFiltres = Commande.hors_devis.all 
      @articlesFiltres = Article.joins(:commande).merge(Commande.hors_devis).all
      @sousArticlesFiltres = Sousarticle.all
      @paiementsFiltres = Paiement.all
    end

      # commandes :
      @nbTotal = @commandesFiltres.count
      @nbRetire = @commandesFiltres.retire.count 
      @nbNonRetire = @commandesFiltres.non_retire.count 
      @nbRendu = @commandesFiltres.rendu.count 
      @groupedByDate = @commandesFiltres.group('DATE(created_at)').count('created_at')

      # articles : 
      @nbTotalArticles = @articlesFiltres.compte_articles
      @nbLoc =   @articlesFiltres.articlesLoues.compte_articles 
      @nbVente =  @articlesFiltres.articlesVendus.compte_articles 
      @groupedByDateArticles =  @articlesFiltres.group('DATE(articles.created_at)').sum('quantite')

      #  ca : 
      @totalCa = @articlesFiltres.sum_articles + @sousArticlesFiltres.sum_sousarticles
      @totalLoc =  @articlesFiltres.articlesLoues.sum_articles + @sousArticlesFiltres.sum_sousarticles
      # en l'etat les sous articles passent que à la vente dans le calcul?
      @totalVente =  @articlesFiltres.articlesVendus.sum_articles 
      @groupedByDateCa =  @articlesFiltres.group('DATE(articles.created_at)').sum('total')
   
      # paiements 
      @totalPaiements =  @paiementsFiltres.sum_paiements
      @totalPrix =  @paiementsFiltres.prix_only.sum_paiements
      @totalCaution =  @paiementsFiltres.caution_only.sum_paiements
      @groupedByDatePaiements =  @paiementsFiltres.group('DATE(created_at)').prix_only.sum_paiements
        
  end 

  private

  def authenticate_vendeur_or_admin!
    unless current_user && (current_user.vendeur? || current_user.admin?)
      redirect_to root_path, alert: "Vous n'avez pas accès à cette page."
    end
  end
  
end
  