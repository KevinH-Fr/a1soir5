module EnsembleHelper

    #  Ensemble complet ? - methodes avec une seule valeur en sortie

    def applicationArticleCourantEnsembleComplet()
        #typeloc = @article.locvente
        typearticle = Produit.find(@article.produit_id).typearticle
       
        if typearticle === "Ensemble"
            applicationVerif = true
        else
            applicationVerif = false
        end
    end

    def ensembleApplicable 
        Ensemble.where(articleparent: @article.produit_id).first
    end 

    def categoriesAttendues
        [self.ensembleApplicable&.categorieenfant, 
         self.ensembleApplicable&.categorieenfant2,
         self.ensembleApplicable&.categorieenfant3,
         self.ensembleApplicable&.categorieenfant4,
         self.ensembleApplicable&.categorieenfant5,
         self.ensembleApplicable&.categorieenfant6
        ].select(&:present?)  #sans valeur nil
    end

    def sousArticlesExistants
        @sousArticlesExistants =  Sousarticle.article_courant(@article.id).ids 
    end

    def typesSousArticlesExistants
        @sousArticlesTypes = self.sousArticlesExistants.map { 
            |sousarticle| 
            Produit.find(Sousarticle.find(sousarticle).produit_id).typearticle
        }
    end

    def elementsManquants
       # if self.categoriesAttendues.present? && self.typesSousArticlesExistants.present? 
            self.categoriesAttendues - self.typesSousArticlesExistants
       # end
    end 

    def completudeEnsemble
        manquants = self.elementsManquants
        if manquants.present?
            false
        else
            true
        end
    end 


    # transformation en article ensemble ? nouveau en methodes avec une seule valeur en sortie
    def articleCourantPossibleEnsemble
        @typeArticleCourant = Produit.find(@article.produit_id).typearticle

        # reherche ce type articel dans tous les ensembles articles enfants
       @articleCourantPossibleEnsemble = 
            Ensemble.where(categorieenfant: @typeArticleCourant).or(
            Ensemble.where(categorieenfant2: @typeArticleCourant).or(
            Ensemble.where(categorieenfant3: @typeArticleCourant)).or(
            Ensemble.where(categorieenfant4: @typeArticleCourant)).or(
            Ensemble.where(categorieenfant5: @typeArticleCourant)).or(
            Ensemble.where(categorieenfant6: @typeArticleCourant))       
        ).ids
    end 
    
    def articlesExistants
        @articlesExistants = Article.commande_courante(@article.commande_id).ids 
    end 

    def typesArticlesExistants
        typesArticlesExistants = []
        self.articlesExistants.each do |article| 
            new_element = Produit.find(Article.find(article).produit_id).typearticle
            typesArticlesExistants << new_element
        end
        @typesArticlesExistants = typesArticlesExistants.uniq.append("") 
    end 

    def ensembleEventuel 
        # trouver un ensemble dont les categories correspondent
        key = self.typesArticlesExistants.append(nil) 
        
        @ensembleEventuel = 
            Ensemble.where(
              categorieenfant: key, 
              categorieenfant2: key,
              categorieenfant3: key,
              categorieenfant4: key, 
              categorieenfant5: key,
              categorieenfant6: key
            ).first
        
    end 

    def produitParent
        Produit.find(self.ensembleEventuel.articleparent)
    end 


    def typesAttendus
        if self.ensembleEventuel.present?
            @typesAttendus = [
                self.ensembleEventuel.categorieenfant, 
                self.ensembleEventuel.categorieenfant2, 
                self.ensembleEventuel.categorieenfant3,
                self.ensembleEventuel.categorieenfant4,
                self.ensembleEventuel.categorieenfant5,
                self.ensembleEventuel.categorieenfant6,
            ]
        end
    end 
    
    def articlesTypes # array avec article id et type categorie
        @articlesTypes = self.articlesExistants.map { 
            |article| 
            [article, Produit.find(Article.find(article).produit_id).typearticle] 
        }
    end 

    def articlesAtransformer 
        @articlesAtransformer = self.articlesTypes.select { 
            |subarray| self.typesAttendus.include?(subarray[1]) }
    end 

end