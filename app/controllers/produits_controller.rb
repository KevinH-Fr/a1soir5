class ProduitsController < ApplicationController
  before_action :authenticate_user!
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

    if datedebut.present? && datefin.present? 
      # ajotuer les osus articles car les produits peuvent passer en sous article ?
      @nbTotal = Article.produit_courant(@produitId).filtredatedebut(datedebut).filtredatefin(datefin).compte_articles
      @locations = Article.produit_courant(@produitId).filtredatedebut(datedebut).filtredatefin(datefin).articlesLoues.compte_articles
      @ventes = Article.produit_courant(@produitId).filtredatedebut(datedebut).filtredatefin(datefin).articlesVendus.compte_articles
   
      @valTotal = Article.produit_courant(@produitId).filtredatedebut(datedebut).filtredatefin(datefin).sum_articles
      @valLocations = Article.produit_courant(@produitId).filtredatedebut(datedebut).filtredatefin(datefin).articlesLoues.sum_articles
      @valVentes = Article.produit_courant(@produitId).filtredatedebut(datedebut).filtredatefin(datefin).articlesVendus.sum_articles
      @groupedByDateProduit = Article.produit_courant(@produitId).filtredatedebut(datedebut).filtredatefin(datefin).group('DATE(created_at)').sum('total')

    else
        # ajotuer les osus articles car les produits peuvent passer en sous article ?
      @nbTotal = Article.produit_courant(@produitId).compte_articles
      @locations = Article.produit_courant(@produitId).articlesLoues.compte_articles
      @ventes = Article.produit_courant(@produitId).articlesVendus.compte_articles
   
      @valTotal = Article.produit_courant(@produitId).sum_articles
      @valLocations = Article.produit_courant(@produitId).articlesLoues.sum_articles
      @valVentes = Article.produit_courant(@produitId).articlesVendus.sum_articles
      @groupedByDateProduit = Article.produit_courant(@produitId).group('DATE(created_at)').sum('total')

    end


    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "etiquette #{@produitId}", # filename
          :margin => {
            :top => 5,
            :bottom => 5
          },
          
          :template => "produits/etiquette",
            footer:  { 
              html: { 
                template:'shared/doc_footer',  
                formats: [:html],      
                layout:  'pdf',  
              },
            },
          
            formats: [:html],
            layout: 'pdf'
      end
    end

  end

  def new
    @produit = Produit.new  

        # valeur si duplicaiton produit 
        if params[:produitbase].present? 
          @produitbase = Produit.find(params[:produitbase]) 
        
          @produit.image1.attach(@produitbase.image1.blob) if @produitbase&.image1&.attached?
        end

  end

  def edit
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
  
    def set_produit
      @produit = Produit.find(params[:id])
    end

    def produit_params
      params.require(:produit).permit(:nom, :prix, :prixlocation, :caution, :description, :categorie, 
          :couleur, :image1, :vitrine, :eshop, :handle, :reffrs, :taille, :quantite, :nomfrs, :dateachat, :prixachat, :typearticle, images: [])
    end

   
end

