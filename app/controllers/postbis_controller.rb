class PostbisController < ApplicationController
  before_action :set_postbi, only: %i[ show edit update destroy ]

  # GET /postbis or /postbis.json
  def index
    @postbis = Postbi.all
  end

  # GET /postbis/1 or /postbis/1.json
  def show
  end

  # GET /postbis/new
  def new 
    @postbi = Postbi.new postbi_params
  end

  # GET /postbis/1/edit
  def edit
  end

  # POST /postbis or /postbis.json
  def create
    @postbi = Postbi.new(postbi_params)

    respond_to do |format|
      if @postbi.save
        format.html { redirect_to postbi_url(@postbi), notice: "Postbi was successfully created." }
        format.json { render :show, status: :created, location: @postbi }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @postbi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postbis/1 or /postbis/1.json
  def update
    respond_to do |format|
      if @postbi.update(postbi_params)
        format.html { redirect_to postbi_url(@postbi), notice: "Postbi was successfully updated." }
        format.json { render :show, status: :ok, location: @postbi }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @postbi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postbis/1 or /postbis/1.json
  def destroy
    @postbi.destroy

    respond_to do |format|
      format.html { redirect_to postbis_url, notice: "Postbi was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_postbi
      @postbi = Postbi.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def postbi_params
      params.fetch(:postbi, {}).permit(:body, :access, :passcode)
    end
end
