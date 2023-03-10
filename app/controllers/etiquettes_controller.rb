class EtiquettesController < ApplicationController
    def index
        # module de gestion des impressions d'étiquettes multiples 
        @produits = Produit.all.order("lower(nom) ASC") # sans capitalisation de lettres

    end

    def edition
       # @etiquette = Etiquette.find(params[:id])

       @produit1 =  Produit.find(params[:prod1]) if params[:prod1].present?
       @produit2 =  Produit.find(params[:prod2]) if params[:prod2].present?
       @produit3 =  Produit.find(params[:prod3]) if params[:prod3].present?
       @produit4 =  Produit.find(params[:prod4]) if params[:prod4].present?

       respond_to do |format|
        format.html
        format.pdf do
          render pdf: "etiquette", # filename
            :margin => {
              :top => 5,
              :bottom => 0
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
