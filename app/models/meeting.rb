class Meeting < ApplicationRecord

# interdire si rv  dejà à la meme heure
    validates :start_time, uniqueness: true

    scope :commande_courante, ->  (commande_courante) { where("commande_id = ?", commande_courante)}
    scope :client_courant, ->  (client_courant) { where("client_id = ?", client_courant)}


  def full_name
    if client_id.present?
      "#{name} - #{Client.find(client_id).full_name}"
    elsif commande_id.present?
      "#{name} - #{ Commande.find(commande_id).auto_short_name} - 
       #{Client.find(Commande.find(commande_id).client_id).full_name}" 
    else
      name 
    end 
  end
  
  def full_details
    if client_id.present?
       "#{Client.find(client_id).full_name} - #{Client.find(client_id).tel}"
    elsif commande_id.present?
       "#{Client.find(Commande.find(commande_id).client_id).full_name} - #{Client.find(Commande.find(commande_id).client_id).tel}"     
    else
              
    end 
  end

end
