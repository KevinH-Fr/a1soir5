class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :authenticate_vendeur_or_admin!
  
  before_action :authenticate_admin!, only: [:import]

  def import
   # render 'clients/import'
    file = params[:file]
    return redirect_to clients_path, notice: "only csv please" unless file.content_type == "text/csv" || file.content_type == "application/vnd.ms-excel"
  
    CsvImportClientsService.new.call(file)

    flash.now[:notice] = "Clients imported successfully."
    respond_to do |format|
      format.html { redirect_to clients_path }
      format.turbo_stream { render turbo_stream: turbo_stream.update("flash", partial: "layouts/flash") }
    end
  end

  def index
    search_params = params.permit(:format, :page, q:[:nom_or_prenom_or_mail_cont])
    @q = Client.ransack(search_params[:q])
    clients = @q.result(distinct: true).order(created_at: :desc)
    @pagy, @clients = pagy_countless(clients, items: 2)
  end

  def show
    @client = Client.find(params[:id])

    @commandes = Commande.client_courant(@client)
    @meetings = Meeting.client_courant(@client)
  end

  def new
    @client = Client.new(client_params)
    @typepropart = Client.typeproparts
    @intitule = Client.intitules
  end

  def edit
    @client = Client.find(params[:id])
    @typepropart = Client.typeproparts
    @intitule = Client.intitules
  
    respond_to do |format|
      format.html
      format.turbo_stream do  
        render turbo_stream: turbo_stream.update(@client, partial: "clients/form", 
          locals: {client: @client})
      end
    end
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|

      if @client.save

          format.html { redirect_to client_url(@client), notice: "Client was successfully created." }
          format.json { render :show, status: :created, location: @client }

      #  else # pour edit d'un record

        #  flash.now[:notice] = "le client #{@client.nom} a bien été ajouté"
       #   format.turbo_stream do
       #     render turbo_stream: [
       #     turbo_stream.prepend("clients", partial: "clients/client",
       #       locals: {client: @client }), 
       #       turbo_stream.update("client_counter", Client.count),
       #       turbo_stream.update("flash", partial: "layouts/flash"),     
       #     ]
       #   end
          
      #  end
        
      else

       # flash.now[:notice] = "erreur - le client n'a pas été ajouté"
       # format.turbo_stream do
       #   render turbo_stream: [
       #     turbo_stream.update("flash", partial: "layouts/flashErreur"),
       #   ]
       # end

        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @client = Client.find(params[:id])
    respond_to do |format|
      if @client.update(client_params)

        format.turbo_stream do  
          render turbo_stream: 
            turbo_stream.update(@client, partial: "clients/client", 
              locals: {client: @client})
        end

        format.html { redirect_to client_url(@client), notice: "Client was successfully updated." }
        format.json { render :show, status: :ok, location: @client }
      else

        format.turbo_stream do  
          render turbo_stream: turbo_stream.update(@client, partial: "clients/form", 
            locals: {client: @client})
        end

        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client.destroy

    flash.now[:notice] = "le client #{@client.nom} a été supprimé"

    respond_to do |format|

      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@client),
          turbo_stream.update("client_counter", Client.count),
          turbo_stream.update("flash", partial: "layouts/flash")
        ]
      end

      format.html { redirect_to clients_url, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def send_client_mail

    client = Client.find(params[:clientId])

    messagemail = Messagemail.find(params[:messagemailId])

    
    ClientMailer.with(client: client).client_created(client, messagemail).deliver_now
      flash[:notice] = "le mail a bien été envoyé"
      redirect_to clients_path()

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
        format.html { redirect_to clients_path }
        format.turbo_stream { render turbo_stream:   turbo_stream.update("flash", partial: "layouts/flash") }
      end

    end
  end

    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.fetch(:client, {}).permit(:nom, :prenom, :typepropart, :contact, :intitule,
        :mail, :mail2, :tel, :tel2, :adresse, :ville, :cp, :pays, :commentaires)
    end
end
