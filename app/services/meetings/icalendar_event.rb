#Meetings::IcalendarEvent.new(meeting: Meeting.first).call

class Meetings::IcalendarEvent
    require 'icalendar/tzinfo'

    include Rails.application.routes.url_helpers

    def initialize(meeting:)
        @meeting = meeting
    end

    def call
        # Create a calendar with an event (standard method)
        
        # plus utilisé car remplacé par le lien vers ajout du calendrier partagé, donc génération du ics avec export pas utile pour le moement 
        
        cal = Icalendar::Calendar.new
    

            cal.event do |e|
                e.dtstart     = @meeting.start_time
                e.dtend       = @meeting.end_time 
                e.summary     = @meeting.name
                e.description = "Have a long lunch meeting and decide nothing..."
                e.ip_class    = "PUBLIC" # PRIVATE
                e.location    = "adresse"
                e.uid         = "rdvid:#{@meeting.id.to_s}"
                e.sequence    = Time.now.to_i
                e.url         = meeting_url(@meeting)
                e.organizer   = Icalendar::Values::CalAddress.new("mailto:#{ApplicationMailer.default_params[:from]}", cn: 'A1 soir app') 
                e.attendee    = Icalendar::Values::CalAddress.new("mailto:kevin.hoffman.france@gmail.com", partstat: 'accepted') 
                #e.status      = "CANCELLED"
            end
            
            cal.publish
            cal.ip_method = "REQUEST"
            cal.to_ical
        
        end 

    end