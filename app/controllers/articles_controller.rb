class ArticlesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_article, only: %i[ show edit update destroy ]

  def index
    @articles = Article.all
  end

  def show
    @sousarticles = Sousarticle.article_courant(@article)
    @typelocvente = ["location", "vente"]
   
  end

  def new
    @article = Article.new article_params

    @commandeId = params[:commandeId]
    session[:commandeId] = params[:commandeId]

    @produitId = params[:produitId]
    session[:produitId] = params[:produitId]

    @sousarticles = Sousarticle.article_courant(@article)
    @typelocvente = ["location", "vente"]
    @quantite = 1
    


    if Produit.exists?(@produitId)
      if @produitId.present?
        @valPrixInitial = Produit.find(@produitId).prix
        @valPrixLocationInitial = Produit.find(@produitId).prixlocation
        @valPrixCautionInitial = Produit.find(@produitId).caution
      end 
    end



    
    if @quantite.present? && @valPrix.present? 
      @valTotal =  @quantite * @valPrix 
    else
      @valTotal = 0  
    end

    categorieVal = params[:categorieVal]
    couleurVal = params[:couleurVal]

    if categorieVal.present?
      @produits = Produit.categorie_selected(categorieVal)
      @couleurs = Produit.categorie_selected(categorieVal).distinct.pluck(:couleur)
        if couleurVal.present?
          @produits = Produit.categorie_selected(categorieVal).couleur_selected(couleurVal)
        end
    else
      @produits = Produit.all 
    end
   
   # @categories = Produit.distinct.pluck(:categorie)
   @categories = Produit.categories.keys

    qVal = params[:q]
    if qVal.present?
      @q = Produit.ransack(params[:q])
      @produits = @q.result(distinct: true)
    end 
  
  end

  def edit

    @produitId = params[:produitId]
    @typelocvente = ["location", "vente"]
    @sousarticles = Sousarticle.article_courant(@article)
  
    if Produit.exists?(@produitId)
      if @produitId.present?
        @valPrixInitial = Produit.find(@produitId).prix
        @valPrixLocationInitial = Produit.find(@produitId).prixlocation
        @valPrixCautionInitial = Produit.find(@produitId).caution
      end 
    end

  end

  def create
    @article = Article.new(article_params)
    #@categories = Produit.distinct.pluck(:categorie)
    @categories = Produit.categories.keys
    @sousarticles = Sousarticle.article_courant(@article)
    @ensembles = Ensemble.all
    @produitId = @article.produit_id
    @commandeId = @article.commande_id

    respond_to do |format|
      if @article.save

        format.html { redirect_to article_path(@article, commandeId: @commandeId, produitId: @produitId, articleId: @article),
                      notice: "L'article a bien été créé"}
        format.json { render :show, status: :created, location: @article }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    @produitId = @article.produit_id
    @commandeId = @article.commande_id

    respond_to do |format|
      if @article.update(article_params)
        format.html  { redirect_to commande_path(@commandeId),
          notice: "L'article a bien été créé" }
        format.json { render :show, status: :ok, location: @article }
        @article.save
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @commandeId = @article.commande_id
    @article.destroy

    respond_to do |format|
      format.html { redirect_to commande_url( @commandeId ), notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_selectProduit
    @commandeId = session[:commandeId]
    @produitId =  session[:produitId]

    redirect_to new_article_path(commandeId: @commandeId, produitId: @produitId),
    notice: "test notif selection produit n°#{@produitId} |"  "commande n°#{@commandeId}"

  end
  
 
  def toggle_transformer_ensemble()
    @article = Article.find(params[:id])
    @ensemble = helpers.ensembleEventuel #recuperer valeur de l'helper ensemble
    @produit = helpers.produitParent

    @typesArticles = helpers.typesArticlesExistants #recuperer valeur de l'helper ensemble
    @articlesAtransformer = helpers.articlesAtransformer

    # ajouter ensemble en article, 
    @articleNew = Article.create(produit_id: @produit.id, commande_id: @article.commande_id, 
      locvente: @article.locvente, quantite: 1, prix: @produit.prix, total: @produit.prix )

    # boucler sur tous les articles a transformer en sous article
    @articlesAtransformer.each do |article|

      Sousarticle.create(article_id: @articleNew.id, prix_sousarticle: 0,
        produit_id: Article.find(article[0]).produit_id)

      # si besoin ajouter autres champs pour faire correspondre ce qui peut l'etre entre article
      # et sous articles

      # puis supprimer les articlesAtranformer car ont été remplacés par des sous articles
      Article.find(article[0]).destroy

    end 

    redirect_to article_path(@articleNew.id, articleId: @articleNew.id, 
      commandeId: @article.commande_id, produitId:  @produit.id),
    notice: "Transformation en ""#{@produit.nom}"" effectuée !"
  end

  private
     def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.fetch(:article, {}).permit(:quantite, :commande_id, :produit_id, :prix, :caution, :total, :locvente, :longueduree)
    end
end
