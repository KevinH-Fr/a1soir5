class EnsemblesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_vendeur_or_admin!
  
  before_action :set_ensemble, only: %i[ show edit update destroy ]

  def index
    search_params = params.permit(:format, :page, 
        q:[:articleparent_or_categorieenfant_or_categorieenfant2_cont])
    @q = Ensemble.ransack(search_params[:q])
    ensembles = @q.result(distinct: true).order(created_at: :desc)
    @pagy, @ensembles = pagy_countless(ensembles, items: 2)
  end

  def show
  end

  def new
    @ensemble = Ensemble.new(ensemble_params)
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream do  
        render turbo_stream: turbo_stream.update(@ensemble, partial: "ensembles/form", 
          locals: {ensemble: @ensemble})
      
      end
    end
  end

  def create
    @ensemble = Ensemble.new(ensemble_params)

    respond_to do |format|
      if @ensemble.save
        format.html { redirect_to ensembles_url(), notice: "ensemble was successfully created." }
        format.json { render :show, status: :created, location: @ensemble }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ensemble.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @ensemble.update(ensemble_params)

        format.turbo_stream do  
          render turbo_stream: 
            turbo_stream.update(@ensemble, partial: "ensembles/ensemble", 
              locals: {ensemble: @ensemble})
        end

        format.html { redirect_to ensemble_url(@ensemble), notice: "ensemble was successfully updated." }
        format.json { render :show, status: :ok, location: @ensemble }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ensemble.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ensemble.destroy

    respond_to do |format|
      
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@ensemble),
         
        ]
      end

      format.html { redirect_to ensembles_url, notice: "ensemble was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
  def authenticate_vendeur_or_admin!
    unless current_user && (current_user.vendeur? || current_user.admin?)
      redirect_to root_path, alert: "Vous n'avez pas accès à cette page."
    end
  end

    def set_ensemble
      @ensemble = Ensemble.find(params[:id])
    end

    def ensemble_params
      params.fetch(:ensemble, {}).permit(:articleparent, :categorieenfant, :categorieenfant2, :categorieenfant3, :categorieenfant4, 
        :categorieenfant5, :categorieenfant6)
    end
end

