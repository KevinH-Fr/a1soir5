class MeetingsController < ApplicationController
#  before_action :authenticate_user!

  before_action :set_meeting, only: %i[ show edit update destroy invite ]
  #skip_before_action :authenticate_user, only: :index #permet partage cal auto sans log
 
  def index
    @meetings = Meeting.all

    @meetings_periode = Meeting.where(
      start_time: Time.now.beginning_of_month.beginning_of_week..
      Time.now.end_of_month.end_of_week)

    @meetings_a_venir = Meeting.where(
        "start_time > ?", Time.now)

    respond_to do |format|
      format.html
      format.ics do
        cal = Icalendar::Calendar.new
        cal.x_wr_calname = 'A1soir_new_app'

        #event_start = DateTime.new 2023, 01, 24, 8, 0, 0
        #event_end = DateTime.new 2023, 01, 24, 11, 0, 0

        #tzid = "Europe/Paris"
        #tz = TZInfo::Timezone.get tzid
        #timezone = tz.ical_timezone event_start
        #cal.add_timezone timezone


        @meetings.each do | meeting |
          details = ""
          name = meeting.name 
          if meeting.client_id.present?
            name  = "#{meeting.name} - #{Client.find(meeting.client_id).full_name}"
            details = "#{Client.find(meeting.client_id).full_name} - #{Client.find(meeting.client_id).tel}"
          end 
          if meeting.commande_id.present?
            name = "#{meeting.name} - #{Client.find(Commande.find(meeting.commande_id).client_id).full_name}" 
            details = "#{Client.find(Commande.find(meeting.commande_id).client_id).full_name} - 
            #{Client.find(Commande.find(meeting.commande_id).client_id).tel}"
          end 

          cal.event do |e|
            e.dtstart     = meeting.start_time #Icalendar::Values::DateTime.new(DateTime.new(meeting.start_time), 'tzid' => tzid)
            e.dtend       = meeting.end_time #"20230124T171500Z"
            e.summary     = name 
            e.description = details

            e.ip_class    = "PUBLIC" # PRIVATE
            e.location    = "adresse"
            e.uid         = "rdvid:#{@meeting.id.to_s}"
            e.sequence    = Time.now.to_i
            e.url         = meeting_url(meeting)
            e.organizer   = Icalendar::Values::CalAddress.new("mailto:#{ApplicationMailer.default_params[:from]}", cn: 'A1 soir app') 
            e.attendee    = Icalendar::Values::CalAddress.new("mailto:kevin.hoffman.france@gmail.com", partstat: 'accepted') 

          
          end
        end
        
        cal.publish
        render plain: cal.to_ical
        
      end 
    end

  end 

  def invite
    MeetingMailer.with(meeting: @meeting).invite.deliver_now
    redirect_to @meeting, notice: "invite send"
  end 


  def show
    if @meeting.commande_id.present?
      @commande = Commande.find(@meeting.commande_id)
    end
    
    if @meeting.client_id.present?
      @client = Client.find(@meeting.client_id)
    end

    respond_to do |format|
      format.html
      format.ics do
       # render plain: @meeting.to_icalendar
      #  send_data  @meeting.to_icalendar, filename: "#{@meeting.name}.ics"
      
        meeting_ics = Meetings::IcalendarEvent.new(meeting: @meeting).call
        send_data  meeting_ics, filename: "#{@meeting.name}.ics"

      end   

    end

  end


  def new
    @meeting = Meeting.new meeting_params

    @commandeId = params[:id]
    session[:commandeId] = @commandeId

    @clientId = ""
    session[:clientId] = @clientId

  end

  def edit

    @commandeId = @meeting.commande_id
    session[:commandeId] = @commandeId

    @clientId = @meeting.client_id
    session[:clientId] = @clientId

    respond_to do |format|
      format.html
      format.turbo_stream do  
        render turbo_stream: turbo_stream.update(@meeting, partial: "meetings/form", 
          locals: {meeting: @meeting})
      end
    end
  end
  
  def create
    @meeting = Meeting.new(meeting_params)

    respond_to do |format|
      if @meeting.save

        if @meeting.commande_id.present?
          format.html { redirect_to commande_url(@meeting.commande_id), notice: "Meeting was successfully created." }
        else
          format.html { redirect_to meetings_path(), notice: "Meeting was successfully created." }
        end 
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @meeting.update(meeting_params)
        if @meeting.commande_id.present?
          format.html { redirect_to commande_url(@meeting.commande_id), notice: "Meeting was successfully updated." }
        else
          format.html { redirect_to meetings_path(), notice: "Meeting was successfully updated." }
        end 
        format.json { render :show, status: :ok, location: @meeting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @meeting.destroy

    respond_to do |format|
      if @meeting.commande_id.present?
        format.html { redirect_to commande_url(@meeting.commande_id), notice: "Meeting was successfully destroyed." }
      else
        format.html { redirect_to meetings_url, notice: "Meeting was successfully destroyed." }
      end 
      format.json { head :no_content }
    end
  end

  def editer_mail()
    @meeting = Meeting.find(params[:id])

    MeetingMailer.with(meeting: @meeting)
    .meeting_created(@meeting).deliver_now
    flash[:notice] = "le mail RDV a bien été envoyé"
    redirect_to meeting_path(@meeting)
  end 

  def toggle_rendezvous_client
    clientId = params[:id]
    #@meeting = Meeting.create(client_id: clientId) 
    #redirect_to meeting_path(@meeting),
    #   notice: "rendez-vous client auto #{clientId}" 

    redirect_to new_meeting_path(clientId: clientId)
    
  end

  def rappel_rdv
   
   @meetings_a_venir = Meeting.where(
    "start_time > ?", Time.now)

    @meetings_a_venir.each do | meeting |
        MeetingMailer.with(meeting: meeting)
        .meeting_created(meeting).deliver_now
        flash[:notice] = "le mail rappel de RDV a bien été envoyé"
    end

   redirect_to meetings_path(),
       notice: "call meetings rappels" 
    
  end


  private
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    def meeting_params
      params.fetch(:meeting, {}).permit(:name, :start_time, :end_time, :commande_id, :client_id, :lieu)
    end
end
