class Post < ApplicationRecord

   # belongs_to :friend


    has_one_attached :avatar

    has_many_attached :images

#    validates :name, presence: true
    validates :content, presence: false

    enum title: {
        draf: 'draft',
        published: 'published',
        passcode_protected: 'passcode_protected'
    }


end
