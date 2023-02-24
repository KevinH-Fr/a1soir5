class Client < ApplicationRecord
    has_many :commandes

    validates :nom, presence: true

    # forcer soit tel soit mail
    validates :tel, presence: true, if: :mail_blank?
    validates :mail, presence: true, if: :tel_blank?
  
    enum typeproparts: ["Particulier", "Professionnel"]
    enum intitules: ["Madame", "Monsieur", "Société", "Entreprise"]

    scope :client_courant, ->  (client_courant) { where("id = ?", client_courant)}

    def mail_blank?
        mail.blank?
    end

    def tel_blank?
        tel.blank?
    end

    def full_name
        "#{prenom} #{nom}"
    end

    def text_record
        "#{intitule} #{nom} #{tel} #{mail} "
    end

    def intitule_nom
        "#{intitule} #{nom}"
    end
end
