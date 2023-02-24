class Meeting < ApplicationRecord

    # interdire si rv  dejà à la meme heure
    validates :start_time, uniqueness: true

    scope :commande_courante, ->  (commande_courante) { where("commande_id = ?", commande_courante)}
    scope :client_courant, ->  (client_courant) { where("client_id = ?", client_courant)}

 #   include Rails.application.routes.url_helpers

 #   def to_icalendar

        # Create a calendar with an event (standard method)
 #       cal = Icalendar::Calendar.new
 #       cal.event do |e|
 #           e.dtstart     = start_time
 #           e.dtend       = end_time
 #           e.summary     = name
 #           e.description = "Have a long lunch meeting and decide nothing..."
 #""           e.ip_class    = "PRIVATE" #PUBLIC
 #""           e.uid         = id.to_s
 #           e.sequence    = Time.now.to_i
 #           e.url         = meeting_url(self)
 #       end
 #       
 #""        cal.publish
 #""        cal.to_ical
 #""    end

end
