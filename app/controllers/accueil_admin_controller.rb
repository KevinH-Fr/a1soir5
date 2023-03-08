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
    @datedebut = DateTime.parse(params[:debut]) if params[:debut].present?
    @datefin = DateTime.parse(params[:fin]) if params[:fin].present?

    if datedebut.present? && datefin.present? 
      # commandes :
      @nbTotal = Commande.filtredatedebut(datedebut).filtredatefin(datefin).count
      @nbRetire = Commande.filtredatedebut(datedebut).filtredatefin(datefin).retire.count 
      @nbNonRetire = Commande.filtredatedebut(datedebut).filtredatefin(datefin).non_retire.count 
      @nbRendu = Commande.filtredatedebut(datedebut).filtredatefin(datefin).rendu.count 
      @groupedByDate = Commande.filtredatedebut(datedebut).filtredatefin(datefin).group('DATE(created_at)').count('created_at')

      # articles : 
      @nbTotalArticles = Article.filtredatedebut(datedebut).filtredatefin(datefin).compte_articles
      @nbLoc =  Article.filtredatedebut(datedebut).filtredatefin(datefin).articlesLoues.compte_articles 
      @nbVente = Article.filtredatedebut(datedebut).filtredatefin(datefin).articlesVendus.compte_articles 
      @groupedByDateArticles = Article.filtredatedebut(datedebut).filtredatefin(datefin).group('DATE(created_at)').sum('quantite')

      #  ca : 
      @totalCa = Article.filtredatedebut(datedebut).filtredatefin(datefin).sum_articles + 
                 Sousarticle.filtredatedebut(datedebut).filtredatefin(datefin).sum_sousarticles
      @totalLoc = Article.filtredatedebut(datedebut).filtredatefin(datefin).articlesLoues.sum_articles + 
                  Sousarticle.filtredatedebut(datedebut).filtredatefin(datefin).sum_sousarticles
      # en l'etat les sous articles passent que à la vente dans le calcul?
      @totalVente = Article.articlesVendus.filtredatedebut(datedebut).filtredatefin(datefin).sum_articles 
      @groupedByDateCa = Article.filtredatedebut(datedebut).filtredatefin(datefin).group('DATE(created_at)').sum('total')
   
      # paiements 
      @totalPaiements = Paiement.filtredatedebut(datedebut).filtredatefin(datefin).sum_paiements
      @totalPrix = Paiement.filtredatedebut(datedebut).filtredatefin(datefin).prix_only.sum_paiements
      @totalCaution = Paiement.filtredatedebut(datedebut).filtredatefin(datefin).caution_only.sum_paiements
      @groupedByDatePaiements = Paiement.filtredatedebut(datedebut).filtredatefin(datefin).group('DATE(created_at)').prix_only.sum_paiements

    else
      # commandes :
      @nbTotal = Commande.count
      @nbRetire = Commande.retire.count 
      @nbNonRetire = Commande.non_retire.count 
      @nbRendu = Commande.rendu.count 
      @groupedByDate = Commande.group('DATE(created_at)').count('created_at')

      # articles : 
      @nbTotalArticles = Article.compte_articles
      @nbLoc =  Article.articlesLoues.compte_articles 
      @nbVente = Article.articlesVendus.compte_articles 
      @groupedByDateArticles = Article.group('DATE(created_at)').sum('quantite')

      # ca : 
      @totalCa = Article.sum_articles + Sousarticle.sum_sousarticles
      @totalLoc =  Article.articlesLoues.sum_articles + Sousarticle.sum_sousarticles
      # en l'etat les sous articles passent que à la vente dans le calcul?
      @totalVente = Article.articlesVendus.sum_articles 
      @groupedByDateCa = Article.group('DATE(created_at)').sum('total')

      # paiements 
      @totalPaiements = Paiement.sum_paiements
      @totalPrix = Paiement.prix_only.sum_paiements
      @totalCaution = Paiement.caution_only.sum_paiements
      @groupedByDatePaiements = Paiement.group('DATE(created_at)').prix_only.sum_paiements

    end 
        
  end 
  
end
  