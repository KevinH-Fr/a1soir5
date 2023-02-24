class Commande < ApplicationRecord
    belongs_to :client
    belongs_to :profile

    has_many :articles, :dependent => :delete_all 
    has_many :paiements, :dependent => :delete_all 

    # forcer soit type event soit date event
    validates :typeevenement, presence: true, if: :dateevenement_blank?
    validates :dateevenement, presence: true, if: :typeevenement_blank?

    enum statutarticleses: ["non-retiré", "retiré", "rendu"]
    enum typeevents: ["soirée", "mariage", "divers"]
    
    enum typedocs: ["bon de commande", "facture", "facture simple"]
    enum typeeditions: ["pdf", "impression", "mail"]

    scope :client_courant, -> (client_courant) { where("client_id = ?", client_courant)}
    scope :non_retire, -> { where("statutarticles = ?", "non-retiré")}
    scope :retire, -> { where("statutarticles = ?", "retiré")}
    scope :rendu, -> { where("statutarticles = ?", "rendu")}

    # disponibilité des produits :
    # scope :periode_loc, -> {where("finloc <= ?", Date.current, 30.days.from_now)}

    scope :a_venir, -> { where('finloc >= ?', Date.current) }
    scope :termine, -> { where('finloc <= ?', Date.current) }
    scope :a_date, -> (a_date) { where('finloc >= ?', a_date) }
    scope :in_date, -> (in_date) { where('finloc <= ?', in_date) }

    def typeevenement_blank?
        typeevenement.blank?
    end

    def dateevenement_blank?
        dateevenement.blank?
    end

    def info_evenement
      "#{typeevenement} #{dateevenement}"
    end

    def full_name
      "n°#{id} | #{nom}"
    end

    def auto_short_name # a ecrire dans la bdd col nom
      "C_#{id}" 
    end

    def auto_name
      "C_#{id}_#{client_id}_#{created_at.strftime("%d%m%y")}" 
    end

    def format_date
      datetime = created_at.to_date
      created_at.strftime("%d/%m/%y")
    end 

    def texte_record
      "n°#{id}  #{type_locvente} #{created_at.strftime("%d/%m/%y")}" 
    end

    def texte_record_nom_client
      "n°#{id}  #{type_locvente} #{created_at.strftime("%d/%m/%y")} | #{Client.find(client_id).full_name}" 
    end 

    def type_locvente
      arr = Article.commande_courante(id).distinct.pluck(:locvente)
      if (arr - ["location"]).empty?
        "location"
      else
        if (arr - ["vente"]).empty?
          "vente"
        else
          "location & vente"
        end
      end
    end


end
