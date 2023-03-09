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
    @produits = Produit.fournisseur_courant(@fournisseur)
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
