class ProduitsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_vendeur_or_admin!

  before_action :set_produit, only: %i[ show edit update destroy ]

  def index

    search_params = params.permit(:format, :page, 
    q:[:nom_or_reffrs_or_categorie_or_couleur_cont])
    @q = Produit.ransack(search_params[:q])
    produits = @q.result(distinct: true).order(created_at: :desc)
    @pagy, @produits = pagy_countless(produits, items: 2)

  end

  def show

    @produitId = params[:id]
    session[:produitId] = @produitId

    #filtres analyses
    datedebut = DateTime.parse(params[:debut]) if params[:debut].present?
    datefin = DateTime.parse(params[:fin]) if params[:fin].present?
    @datedebut = DateTime.parse(params[:debut]) if params[:debut].present?
    @datefin = DateTime.parse(params[:fin]) if params[:fin].present?

    @initial = Produit.find(@produitId).quantite

    #totaux hors filtres :
    @articlesFiltres = Article.produit_courant(@produitId)
    @totLocations =  @articlesFiltres.joins(:commande).merge(Commande.hors_devis).articlesLoues.compte_articles
    @totVentes =  @articlesFiltres.joins(:commande).merge(Commande.hors_devis).articlesVendus.compte_articles 
    @louesTermines = Commande.hors_devis.termine.joins(:articles).merge(@articlesFiltres.articlesLoues).sum(:quantite) 
    @louesAvenir = Commande.hors_devis.a_venir.joins(:articles).merge(@articlesFiltres.articlesLoues).sum(:quantite) 

    if datedebut.present? && datefin.present? 
      @articlesFiltres = Article.produit_courant(@produitId).filtredatedebut(datedebut).filtredatefin(datefin)
    else
      @articlesFiltres = Article.produit_courant(@produitId)
    end
    
      # ajotuer les osus articles car les produits peuvent passer en sous article ?
      @nbTotal =  @articlesFiltres.joins(:commande).merge(Commande.hors_devis).compte_articles
      @locations = @articlesFiltres.articlesLoues.compte_articles
      @ventes = @articlesFiltres.articlesVendus.compte_articles
      @valTotal = @articlesFiltres.sum_articles
      @valLocations = @articlesFiltres.articlesLoues.sum_articles
      @valVentes = @articlesFiltres.articlesVendus.sum_articles
      @groupedByDateProduit = @articlesFiltres.group('DATE(created_at)').sum('total')

  end

  def new
    @produit = Produit.new  
    @fournisseurs = Fournisseur.all

        # valeur si duplicaiton produit 
        if params[:produitbase].present? 
          @produitbase = Produit.find(params[:produitbase]) 
        
          @produit.image1.attach(@produitbase.image1.blob) if @produitbase&.image1&.attached?
        end

  end

  def edit

    @fournisseurs = Fournisseur.all
    @handle = @produit.nom.parameterize
    
    respond_to do |format|
      format.html
      format.turbo_stream do  
        render turbo_stream: turbo_stream.update(@produit, partial: "produits/form", 
          locals: {produit: @produit})
      end
    end
  end

  def create
    @produit = Produit.new(produit_params)
  
    respond_to do |format|
      if @produit.save

      #    format.turbo_stream do
      #      render turbo_stream: [
      #        turbo_stream.prepend("produits", partial: "produits/produit",
      #        locals: {produit: @produit }),
      #      ]
      #    end
        
        format.html { redirect_to produit_url(@produit), notice: "Produit was successfully created." }
        format.json { render :show, status: :created, location: @produit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @produit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @produit.update(produit_params)

        format.turbo_stream do  
          render turbo_stream: turbo_stream.update(@produit, partial: "produits/produit", locals: {produit: @produit})
        end

        format.html { redirect_to produit_url(@produit), notice: "Produit was successfully updated." }
        format.json { render :show, status: :ok, location: @produit }
      else

        format.turbo_stream do  
          render turbo_stream: turbo_stream.update(@produit, partial: "produits/form", locals: {produit: @produit})
        end

        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @produit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @produit.destroy

    flash.now[:notice] = "le produit #{@produit.nom} a été supprimé"

    respond_to do |format|

      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@produit),
          turbo_stream.update("produit_counter", Produit.count),
          turbo_stream.update("flash", partial: "layouts/flash")
        ]
      end

    #  format.html { redirect_to produits_url, notice: "Produit was successfully destroyed." }
    #  format.json { head :no_content }
    end
  end


  def dupliquer

    @produit = Produit.find(params[:id])

    if params[:produitbase].present?
      @produitBase = Produit.find(params[:produitbase]) 

      # préparer un nouveau produit qui contient les memes datas que le courant
      #tester full duplication
      original = @produitBase
      copy = original.dup
      copy.nom = "#{original.nom}_new" # append "new" to the original name
      copy.image1.attach \
        :io           => StringIO.new(original.image1.download),
        :filename     => original.image1.filename,
        :content_type => original.image1.content_type

      copy.save!

    end

      redirect_to produits_path(),
      notice: "Duplication du produit !"

  end 

  private

  def authenticate_vendeur_or_admin!
    unless current_user && (current_user.vendeur? || current_user.admin?)
      redirect_to root_path, alert: "Vous n'avez pas accès à cette page."
    end
  end
  
    def set_produit
      @produit = Produit.find(params[:id])
    end

    def produit_params
      params.require(:produit).permit(:nom, :prix, :prixlocation, :caution, :description, :categorie, 
          :couleur, :image1, :vitrine, :eshop, :handle, :reffrs, :taille, :quantite, :nomfrs, :fournisseur_id, :dateachat, :prixachat, :typearticle, images: [])
    end

   
end

