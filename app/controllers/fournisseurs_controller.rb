class FournisseursController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fournisseur, only: %i[ show edit update destroy ]

  def index
    search_params = params.permit(:format, :page, q:[:nom_or_pays_or_tel_or_mail_cont])
    @q = Fournisseur.ransack(search_params[:q])
    fournisseurs = @q.result(distinct: true).order(created_at: :desc)
    @pagy, @fournisseurs = pagy_countless(fournisseurs, items: 2)
  end

  def show

    datedebut = DateTime.parse(params[:debut]) if params[:debut].present?
    datefin = DateTime.parse(params[:fin]) if params[:fin].present?
    @datedebut = DateTime.parse(params[:debut]) if params[:debut].present?
    @datefin = DateTime.parse(params[:fin]) if params[:fin].present?

    if datedebut.present? && datefin.present? 

      @produits = Produit.filtredatedebut(datedebut).filtredatefin(datefin).fournisseur_courant(@fournisseur)
      @nbProduits = @produits.compte_produits
      @valProduits = 0
      @produits.each do |produit|
        @valProduits += produit.quantite * produit.prixachat
      end

      @nbSoiree =  @produits.categorie_robes_soirees.compte_produits
      @nbMariee =  @produits.categorie_robes_mariees.compte_produits
      @nbCostume =  @produits.categorie_costumes_hommes.compte_produits
      @nbAccessoire =  @produits.categorie_accessoires.compte_produits
      @nbDeguisement =  @produits.categorie_costumes_deguisements.compte_produits

      @valSoiree = 0
      @produits.categorie_robes_soirees.each do |produit|
        @valSoiree += produit.quantite * produit.prixachat
      end

      @valMariee = 0
      @produits.categorie_robes_mariees.each do |produit|
        @valMariee += produit.quantite * produit.prixachat
      end

      @valCostume = 0
      @produits.categorie_costumes_hommes.each do |produit|
        @valCostume += produit.quantite * produit.prixachat
      end

      @valAccessoire = 0
      @produits.categorie_accessoires.each do |produit|
        @valAccessoire += produit.quantite * produit.prixachat
      end
      
      @valDeguisement = 0
      @produits.categorie_costumes_deguisements.each do |produit|
        @valDeguisement += produit.quantite * produit.prixachat
      end
      
      @groupedByDateFournisseur = @produits.group("DATE(dateachat)").sum("prixachat * quantite")

      @premierAchat = @produits.order(dateachat: :asc).first
      @dernierAchat = @produits.order(dateachat: :desc).first
    
    else
    
      @produits = Produit.fournisseur_courant(@fournisseur)
      @nbProduits = @produits.compte_produits
      @valProduits = 0
      @produits.each do |produit|
        @valProduits += produit.quantite * produit.prixachat
      end

      @nbSoiree = @produits.categorie_robes_soirees.compte_produits
      @nbMariee = @produits.categorie_robes_mariees.compte_produits
      @nbCostume = @produits.categorie_costumes_hommes.compte_produits
      @nbAccessoire = @produits.categorie_accessoires.compte_produits
      @nbDeguisement = @produits.categorie_costumes_deguisements.compte_produits

      @valSoiree = 0
      @produits.categorie_robes_soirees.each do |produit|
        @valSoiree += produit.quantite * produit.prixachat
      end

      @valMariee = 0
      @produits.categorie_robes_mariees.each do |produit|
        @valMariee += produit.quantite * produit.prixachat
      end

      @valCostume = 0
      @produits.categorie_costumes_hommes.each do |produit|
        @valCostume += produit.quantite * produit.prixachat
      end

      @valAccessoire = 0
      @produits.categorie_accessoires.each do |produit|
        @valAccessoire += produit.quantite * produit.prixachat
      end
      
      @valDeguisement = 0
      @produits.categorie_costumes_deguisements.each do |produit|
        @valDeguisement += produit.quantite * produit.prixachat
      end
      
      @groupedByDateFournisseur = @produits.group("DATE(dateachat)").sum("prixachat * quantite")

      @premierAchat = @produits.order(dateachat: :asc).first
      @dernierAchat = @produits.order(dateachat: :desc).first

    end

  end

  def new
    @fournisseur = Fournisseur.new
  end

  def edit

    respond_to do |format|
      format.html
      format.turbo_stream do  
        render turbo_stream: turbo_stream.update(@fournisseur, partial: "fournisseurs/form", 
          locals: {fournisseur: @fournisseur})
      end
    end

  end

  def create
    @fournisseur = Fournisseur.new(fournisseur_params)

    respond_to do |format|
      if @fournisseur.save

        flash.now[:notice] = "le fournisseur #{@fournisseur.id} a été ajouté"

        format.turbo_stream do
           render turbo_stream: [
             turbo_stream.prepend("fournisseurs", partial: "fournisseurs/fournisseur",
             locals: {fournisseur: @fournisseur }), 
             turbo_stream.update("fournisseur_counter", Fournisseur.count),
             turbo_stream.update("flash", partial: "layouts/flash"),
           ]
        end

        format.html { redirect_to fournisseur_url(@fournisseur), notice: "fournisseur was successfully created." }
        format.json { render :show, status: :created, location: @fournisseur }
      else

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('new_fournisseur', partial: "fournisseurs/form", 
              locals: {fournisseur: @fournisseur  }),
          ]
        end

        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fournisseur.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @fournisseur.update(fournisseur_params)

        format.turbo_stream do  
          render turbo_stream: turbo_stream.update(@fournisseur, partial: "fournisseurs/fournisseur", 
            locals: {fournisseur: @fournisseur})
        end

        format.html { redirect_to fournisseurs_url, notice: "fournisseur was successfully updated." }
        format.json { render :show, status: :ok, location: @fournisseur }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fournisseur.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @fournisseur.destroy

    respond_to do |format|
      format.html { redirect_to fournisseurs_url, notice: "Fournisseur was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_fournisseur
      @fournisseur = Fournisseur.find(params[:id])
    end

    def fournisseur_params
      params.fetch(:fournisseur, {}).permit(:nom, :pays, :telephone, :mail, :representant, :notes)
    end
end
