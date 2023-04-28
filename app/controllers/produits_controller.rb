class ProduitsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :authenticate_vendeur_or_admin!

  before_action :authenticate_admin!, only: [:import]

  before_action :set_produit, only: %i[ show edit update destroy ]

  def import
    # render 'clients/import'
     file = params[:file]
     return redirect_to produits_path, notice: "only csv please" unless file.content_type == "text/csv" || file.content_type == "application/vnd.ms-excel"
   
     CsvImportProduitsService.new.call(file)
 
     flash.now[:notice] = "Produits imported successfully."
     respond_to do |format|
       format.html { redirect_to produits_path }
       format.turbo_stream { render turbo_stream: turbo_stream.update("flash", partial: "layouts/flash") }
     end
   end

  def index

    search_params = params.permit(:format, :page, 
    q:[:nom_or_reffrs_or_categorie_or_couleur_cont])
    @q = Produit.ransack(search_params[:q])
    produits = @q.result(distinct: true).order(created_at: :desc)
    @pagy, @produits = pagy_countless(produits, items: 2)

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

  def show
    @produitId = params[:id]
    session[:produitId] = @produitId

    first_day = Date.current.beginning_of_month
    last_day = Date.current.end_of_month
  
    if params[:debut].present?
      @datedebut = DateTime.parse(params[:debut])
    else
      @datedebut = DateTime.parse(first_day)
    end

    if params[:fin].present?
      @datefin = DateTime.parse(params[:fin]) 
    else
      @datefin = DateTime.parse(last_day)
    end

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

    end
  end


  def dupliquer

    @produit = Produit.find(params[:id])

    if params[:produitbase].present?
      @produitBase = Produit.find(params[:produitbase]) 

      # préparer un nouveau produit qui contient les memes datas que le courant
      original = @produitBase
      copy = original.dup
      copy.nom = "#{original.nom}_new" # append "new" to the original name
      copy.image1.attach \
        :io           => StringIO.new(original.image1.download),
        :filename     => original.image1.filename,
        :content_type => original.image1.content_type

      original.images.each do |image|
        copy.images.attach \
          io: StringIO.new(image.download),
          filename: image.filename,
          content_type: image.content_type
      end
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

  def authenticate_admin!
    unless current_user && (current_user.admin?)
     # redirect_to clients_path, alert: "Vous n'avez pas accès à cette fonction."
      flash.now[:notice] = "Vous n'avez pas accès à cette fonction."
      respond_to do |format|
        format.html { redirect_to produits_path }
        format.turbo_stream { render turbo_stream:   turbo_stream.update("flash", partial: "layouts/flash") }
      end
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
