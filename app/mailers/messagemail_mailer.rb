class MessagemailMailer < ApplicationMailer

  helper CommandeHelper #rendre disponible l'helper commande pour calculs synthese

  def messagemail_created(messagemail, commande, client)

      @messagemail = messagemail
      @commande = commande
      @client = client

      @clientMail = @messagemail.mail,
  
      @mailobject = @messagemail.titre
      @texteBase = @messagemail.bodymail

      if @commande.present?

        @intituleClient = Client.find(@client.id).intitule_nom
        typedoc = @messagemail.typedoc

        edition_pdf = @messagemail.editpdf
        edition_mail = @messagemail.editmail
        edition_print = @messagemail.editprint

        @nomDocument = "#{typedoc}_" "#{@commande.id}"
        @pdf = params[:pdf]
        attachments["#{@nomDocument}.pdf"] = @pdf 

        if Commande.find(@commande.id).typeevenement.present?
          @evenement = Commande.find(@commande.id).typeevenement
        else
          @evenement = "événement"
        end 
    
        if Commande.find(@commande.id).dateevenement.present?
          @dateEvent = " du #{Commande.find(@commande.id).dateevenement.strftime("%d/%m/%y")}"
        else
          @dateEvent = ""
        end 
       
        @dateEvent = Commande.find(@commande.id).dateevenement ? " du 
          #{Commande.find(@commande.id).dateevenement.strftime("%d/%m/%y")}" : ""
      
      else # si mail client sans commande
        @intituleClient = Client.find(@messagemail.client_id).intitule_nom
       
      end
    
        mail(
          to: @messagemail.mail,
          subject: @mailobject, 
          cc: "kevin.hoffman.france@gmail.com"
          
        )
    
  end
end
