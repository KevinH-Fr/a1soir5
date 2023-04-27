class SousarticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_vendeur_or_admin!

  before_action :set_sousarticle, only: %i[ show edit update destroy ]

  def index
    @sousarticles = Sousarticle.all
  end

  def show
  end

  def new
    @sousarticle = Sousarticle.new sousarticle_params

    @articleId = params[:articleId]
    session[:articleId] = params[:articleId]

    @produitId = params[:produitId]

    @typelocvente = ["location", "vente"]
   # @natures = Modelsousarticle.distinct.pluck(:nature)

    if @produitId.present?
      @valPrix = Produit.find(@produitId).prix
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
    

  end

  def new_multiple

    @commandeId =  session[:commandeId]
    @articleId = params[:articleId]
    session[:articleId] = params[:articleId]
    @articleLocVente = Article.find(@articleId).locvente
    @typelocvente = ["location", "vente"]

    @produits_ids = Produit.find(params[:produits_ids])
    @nbElements = params[:nbElements].to_i
    
    @sousarticles = []
    @nbElements.times { @sousarticles << Sousarticle.new }
  end

  def edit
  
    @produitId = params[:produitId]

   # @articleId = params[:articleId]
    #session[:articleId] = params[:articleId]

  #  @natures = Modelsousarticle.distinct.pluck(:nature)
  #  @produitId = params[:produitId]

     respond_to do |format|
      format.html
      format.turbo_stream do  
        render turbo_stream: turbo_stream.update(@sousarticle, partial: "sousarticles/form", 
          locals: {sousarticle: @sousarticle})
      end
    end

  end

  def create
    @articleId = params[:articleId]
    @sousarticle = Sousarticle.new(sousarticle_params)
    @commandeId = session[:commandeId]

   # @produitId = Article.find(@sousarticle.article_id).produit_id

    permitted_array = [:article_id, :produit_id, :prix_sousarticle, :caution_sousarticle, :commentaire]
    if params[:sousarticle]
      Sousarticle.create(params[:sousarticle].permit(permitted_array))
    else
      params[:sousarticles].each do |index, sousarticle_params|
        Sousarticle.create(sousarticle_params.permit(permitted_array))
      end
    end
    redirect_to commande_path(@commandeId)

   # respond_to do |format|
   #   if @sousarticle.save
   #     format.html { redirect_to article_path(@sousarticle.article_id, commandeId: @commandeId, produitId:  @produitId), 
   #          notice: "Sousarticle was successfully created." }
   #     format.json { render :show, status: :created, location: @sousarticle }
   #   else
   #     format.html { render :new, status: :unprocessable_entity }
   #     format.json { render json: @sousarticle.errors, status: :unprocessable_entity }
   #   end
   # end
  end

  def update
    @commandeId = Article.find(@sousarticle.article_id).commande_id
    @produitId = Article.find(@sousarticle.article_id).produit_id
   # @natures = Modelsousarticle.distinct.pluck(:nature)
    @articleId = params[:articleId]

    respond_to do |format|
      if @sousarticle.update(sousarticle_params)

        format.turbo_stream do  
          render turbo_stream: turbo_stream.update(@sousarticle, partial: "sousarticles/sousarticle",
             locals: {sousarticle: @sousarticle})
        end

        format.html { redirect_to edit_article_path(@sousarticle.article_id, commandeId: @commandeId, produitId:  @produitId), 
            notice: "Sousarticle was successfully updated." }

      #  format.html { redirect_to article_path(@sousarticle.article_id, commandeId: @commandeId, produitId:  @produitId), 
      #  notice: "Sousarticle was successfully updated." }
             
        format.json { render :show, status: :ok, location: @sousarticle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sousarticle.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    @commandeId = Article.find(@sousarticle.article_id).commande_id
    @produitId = Article.find(@sousarticle.article_id).produit_id

    @sousarticle.destroy

    respond_to do |format|
      format.html { redirect_to edit_article_path(@sousarticle.article_id, commandeId: @commandeId, produitId:  @produitId), 
        notice: "Sousarticle was successfully destroyed." }
      format.json { head :no_content }
    end
  end



  private

  def authenticate_vendeur_or_admin!
    unless current_user && (current_user.vendeur? || current_user.admin?)
      redirect_to root_path, alert: "Vous n'avez pas accès à cette page."
    end
  end

    def set_sousarticle
      @sousarticle = Sousarticle.find(params[:id])
    end

    def sousarticle_params
      params.fetch(:sousarticle, {}).permit(:article_id, :produit_id, :nature, :description, 
        :prix_sousarticle, :caution_sousarticle, :taille, :commentaire)
    end
end
