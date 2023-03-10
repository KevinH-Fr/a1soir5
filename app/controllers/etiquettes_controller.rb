class EtiquettesController < ApplicationController
    def index
        # module de gestion des impressions d'étiquettes multiples 
        @produits = Produit.all.order("lower(nom) ASC") # sans capitalisation de lettres

    end

    def edition
       # @etiquette = Etiquette.find(params[:id])

       @produitId =  34 #params[:prod1]

       respond_to do |format|
        format.html
        format.pdf do
          render pdf: "etiquette #{@produitId}", # filename
            :margin => {
              :top => 5,
              :bottom => 5
            },
            
            :template => "etiquettes/edition",
              footer:  { 
                html: { 
                  template:'shared/doc_footer',  
                  formats: [:html],      
                  layout:  'pdf',  
                },
              },
            
              formats: [:html],
              layout: 'pdf'
        end
      end

    end 


end
