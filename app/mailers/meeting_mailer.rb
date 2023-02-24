class MeetingMailer < ApplicationMailer

  def invite
    @greeting = "hi"
    @meeting = params[:meeting]
    calendar_event = Meetings::IcalendarEvent.new(meeting: @meeting).call
    attachments['invite.ics'] = calendar_event
    mail to: "kevin.hoffman.france@gmail.com", #Client.find(@meeting.client_id).mail,
         cc: "kevin.hoffman.france@gmail.com",
         subject: @meeting.name
  end 

  def reminder(meeting)

   # MeetingMailer.reminder().deliver_now
  
    @meeting = meeting

    if @meeting.client_id.present?
      @client = Client.find(@meeting.client_id)
    else
      @client = Client.find(Commande.find(@meeting.commande_id).client_id)
    end

    @dateRdv = @meeting.start_time.strftime("%d/%m/%y" " à %H:%M")
    @intituleClient = @client.intitule_nom
    @texteBase = "Vous avez un rendez-vous programmé le #{@dateRdv}."

    if @client.present?
      mail(
        to: @client.mail,
        subject: "Rappel RDV du #{@dateRdv}", 
        cc: "kevin.hoffman.france@gmail.com"
      )
    end
  
  end

    # pas utilisé
    def meeting_created(meeting)
  
        @meeting = meeting

        if @meeting.client_id.present?
          @client = Client.find(@meeting.client_id)
        else
          @client = Client.find(Commande.find(@meeting.commande_id).client_id)
        end

        @dateRdv = @meeting.start_time.strftime("%d/%m/%y" " à %H:%M")
        @intituleClient = @client.intitule_nom
        @texteBase = "Vous avez un rendez-vous programmé le #{@dateRdv}."

          mail(
            to: @client.mail,
            subject: "Rappel RDV du #{@dateRdv}", 
            cc: "kevin.hoffman.france@gmail.com"
            
          )
      
    end


end
