class AccueilController < ApplicationController
  layout 'public' # utiliser le layout specific pour la partie site public

    def mariees
      
      @produits = Produit.categorie_robes_mariees.showed_vitrine
      search_params = params.permit(:format, :page, :commit, 
        q:[:nom_or_reffrs_or_categorie_or_couleur_cont])
      @q = Produit.categorie_robes_mariees.showed_vitrine.ransack(search_params[:q])
      produits = @q.result(distinct: true).order(created_at: :desc)
      @pagy, @produits = pagy(produits, items: 2)


      if Label.last.present?
        @label = Label.last.mariee
      end
    end

    def costumes

      @produits = Produit.categorie_costumes_hommes.showed_vitrine
      search_params = params.permit(:format, :page, 
        q:[:nom_or_reffrs_or_categorie_or_couleur_cont])
      @q = Produit.categorie_costumes_hommes.showed_vitrine.ransack(search_params[:q])
      produits = @q.result(distinct: true).order(created_at: :desc)
      @pagy, @produits = pagy(produits, items: 2)

      if Label.last.present?
        @label = Label.last.homme
      end
    end

    def soirees

      @produits = Produit.categorie_robes_soirees.showed_vitrine
      search_params = params.permit(:format, :page, 
        q:[:nom_or_reffrs_or_categorie_or_couleur_cont])
      @q = Produit.categorie_robes_soirees.showed_vitrine.ransack(search_params[:q])
      produits = @q.result(distinct: true).order(created_at: :desc)
      @pagy, @produits = pagy(produits, items: 2)

     
      if Label.last.present?
        @label = Label.last.soiree
      end
    end

    def accessoires

     @produits = Produit.categorie_accessoires.showed_vitrine
     search_params = params.permit(:format, :page, 
       q:[:nom_or_reffrs_or_categorie_or_couleur_cont])
     @q = Produit.categorie_accessoires.showed_vitrine.ransack(search_params[:q])
     produits = @q.result(distinct: true).order(created_at: :desc)
     @pagy, @produits = pagy(produits, items: 2)

      if Label.last.present?
        @label = Label.last.accessoire
      end
    end

    def deguisements

      @produits = Produit.categorie_costumes_deguisements.showed_vitrine
      search_params = params.permit(:format, :page, 
        q:[:nom_or_reffrs_or_categorie_or_couleur_cont])
      @q = Produit.categorie_costumes_deguisements.showed_vitrine.ransack(search_params[:q])
      produits = @q.result(distinct: true).order(created_at: :desc)
      @pagy, @produits = pagy(produits, items: 2)

      if Label.last.present?
        @label = Label.last.deguisement
      end
    end

    def index
   #   @texteContact = Texte.last.contact if Texte.last.present?
   #   @texteHoraire = Texte.last.horaire if Texte.last.present?
   #   @texteAdresse = Texte.last.adresse if Texte.last.present?
      
   #   if Label.last.present?
   #     @label = Label.last.principale
   #   end

    end

    def boutique
      
      if Label.last.present?
        @label = Label.last.boutique
      end

      if Texte.last.present?
        @texteContact = Texte.last.contact
        @texteHoraire = Texte.last.horaire
        @texteBoutique = Texte.last.boutique
        @texteAdresse = Texte.last.adresse
      end
    end
  
    def contact
      if Texte.last.present?
        @texteContact = Texte.last.contact
        @texteHoraire = Texte.last.horaire
        @texteBoutique = Texte.last.boutique
        @texteAdresse = Texte.last.adresse
      end
    end

    def infos
      if Texte.last.present?
        @texteContact = Texte.last.contact
        @texteHoraire = Texte.last.horaire
        @texteAdresse = Texte.last.adresse
      end

      if Label.last.present?
        @label = Label.last.info
      end
    end


  end
  