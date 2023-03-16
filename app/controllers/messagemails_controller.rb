class MessagemailsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_vendeur_or_admin!
  
  before_action :set_messagemail, only: %i[ show edit update destroy ]

  def index
    @messagemails = Messagemail.all
  end

  def show
  end

  def new
    @messagemail = Messagemail.new messagemail_params

    @typedocs = ["commande", "facture", "facture_simple"]

  end

  def edit
    @typedocs = ["commande", "facture", "facture_simple"]
  #  respond_to do |format|
  #    format.html
  #    format.turbo_stream do  
  #      render turbo_stream: turbo_stream.update(@messagemail, partial: "messagemails/form", 
  #        locals: {messagemail: @messagemail})
  #    end
  #  end
  end

  def create
   
    @messagemail = Messagemail.new(messagemail_params)

    respond_to do |format|
      if @messagemail.save
        messagemail = @messagemail
        format.html { 
         redirect_to messagemail_url(@messagemail),
          notice: "L'édition a bien été préparée." 
          }

        format.json { render :show, status: :created, location: @messagemail }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @messagemail.errors, status: :unprocessable_entity }
  
      end
    end
  end

  def update
    respond_to do |format|
      if @messagemail.update(messagemail_params)
        format.html { redirect_to messagemail_url(@messagemail), notice: "Messagemail was successfully updated." }
        format.json { render :show, status: :ok, location: @messagemail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @messagemail.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @messagemail.destroy

    respond_to do |format|
      format.html { redirect_to messagemails_url, notice: "Messagemail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def editer_pdf()

    @messagemail = Messagemail.find(params[:id])

     typedoc = @messagemail.typedoc
  
     if typedoc.present?
  
       @commande = Commande.find(@messagemail.commande_id)
       @client = Client.find(@commande.client_id)
  
       pdf = WickedPdf.new.pdf_from_string(
         render_to_string(
           template: "pdf/bonCommande", 
           formats: [:html],
           disposition: :inline,              
           layout: 'pdf'
         ),
           header: {
             content: render_to_string(
               'shared/doc_entete',
               layout: 'pdf'
             )
           },
           footer: {
             content: render_to_string(
               'shared/doc_footer',
               layout: 'pdf'
             )
           }
         )
    
     end
  
       send_data pdf,
       filename: "#{typedoc}_" "#{@commande.id}.pdf",
       type: 'application/pdf',
       disposition: 'inline'
  
  end 

  def editer_mail()

   @messagemail = Messagemail.find(params[:id])

   typedoc = @messagemail.typedoc
   edition_pdf = @messagemail.editpdf
   edition_mail = @messagemail.editmail
   edition_print = @messagemail.editprint

   if typedoc.present?

     @commande = Commande.find(@messagemail.commande_id)
     @client = Client.find(@commande.client_id)

     pdf = WickedPdf.new.pdf_from_string(
       render_to_string(
         template: "pdf/bonCommande", 
         formats: [:html],
         disposition: :inline,              
         layout: 'pdf'
       ),
         header: {
           content: render_to_string(
             'shared/doc_entete',
             layout: 'pdf'
           )
         },
         footer: {
           content: render_to_string(
             'shared/doc_footer',
             layout: 'pdf'
           )
         }
       )

     MessagemailMailer.with(messagemail: @messagemail, commande: @commande, pdf: pdf)
      .messagemail_created(@messagemail, @commande, @client).deliver_now
      flash[:notice] = "le mail avec commande a bien été envoyé"

   else #si mail client sans commande
     MessagemailMailer.with(messagemail: @messagemail, commande: @commande, pdf: pdf)
     .messagemail_created(@messagemail, @commande, @client).deliver_now
     flash[:notice] = "le mail client a bien été envoyé"
    
   end

   redirect_to messagemail_path(@messagemail)

  end 

  private

  
  def authenticate_vendeur_or_admin!
    unless current_user && (current_user.vendeur? || current_user.admin?)
      redirect_to root_path, alert: "Vous n'avez pas accès à cette page."
    end
  end

    def set_messagemail
      @messagemail = Messagemail.find(params[:id])
    end

    def messagemail_params
      params.fetch(:messagemail, {}).permit(:titre, :body, :commande_id, :client_id, :mail, :intitule, 
                :commentairedoc, :commentairefasimple, :typedoc, :editpdf, :editmail, :bodymail)
    end
end
