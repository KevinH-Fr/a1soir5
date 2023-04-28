module CalculsProduitHelper

    # valeurs du tableau stock en aboslu sans filtre de dates possible
    def stockInitial(produit)
       Produit.find(produit).quantite
    end

    def totLocations(produit)
        Article.produit_courant(produit).hors_devis.articlesLoues.compte_articles +
        Sousarticle.produit_courant(produit).hors_devis.sousarticlesLoues.count
    end

    def totVentes(produit)
        Article.produit_courant(produit).hors_devis.articlesVendus.compte_articles +
        Sousarticle.produit_courant(produit).hors_devis.sousarticlesVendus.count
    end

    def louesTermines(produit)
        Article.produit_courant(produit).hors_devis.termine.compte_articles +
        Sousarticle.produit_courant(produit).hors_devis.termine.compte_sousarticles
    end

    def louesAvenir(produit)
        Article.produit_courant(produit).hors_devis.a_venir.compte_articles +
        Sousarticle.produit_courant(produit).hors_devis.a_venir.compte_sousarticles
    end

    def restant(produit)
        stockInitial(produit) - louesAvenir(produit) - totVentes(produit)
    end

    # calculs pour graphs avec filtre de dates
    def locationsFiltreDates(produit, datedebut, datefin)
        Article.produit_courant(produit).hors_devis.articlesLoues
            .filtredatedebut(datedebut).filtredatefin(datefin).compte_articles   +
        Sousarticle.produit_courant(produit).hors_devis.sousarticlesLoues
            .filtredatedebut(datedebut).filtredatefin(datefin).count
    end

    def ventesFiltreDates(produit, datedebut, datefin)
        Article.produit_courant(produit).hors_devis.articlesVendus
        .filtredatedebut(datedebut).filtredatefin(datefin).compte_articles +
        Sousarticle.produit_courant(produit).hors_devis.sousarticlesVendus
        .filtredatedebut(datedebut).filtredatefin(datefin).count
    end

    def valLocationsFiltreDates(produit, datedebut, datefin)
        Article.produit_courant(produit).hors_devis.articlesLoues
        .filtredatedebut(datedebut).filtredatefin(datefin).sum_articles +
        Sousarticle.produit_courant(produit).hors_devis.sousarticlesLoues
        .filtredatedebut(datedebut).filtredatefin(datefin).sum_sousarticles
    end

    def valVentesFiltreDates(produit, datedebut, datefin)
        Article.produit_courant(produit).hors_devis.articlesVendus
        .filtredatedebut(datedebut).filtredatefin(datefin).sum_articles +
        Sousarticle.produit_courant(produit).hors_devis.sousarticlesVendus
        .filtredatedebut(datedebut).filtredatefin(datefin).sum_sousarticles
    end

    def groupByDateTotal(produit, datedebut, datefin)
        hash1 = Article.produit_courant(produit).hors_devis
            .filtredatedebut(datedebut).filtredatefin(datefin)
            .joins(:commande).group('DATE(commandes.created_at)').sum('total')
        hash2 = Sousarticle.produit_courant(produit).hors_devis
            .filtredatedebut(datedebut).filtredatefin(datefin)
            .group("DATE(created_at)").sum(:prix_sousarticle)
        combined_hash = hash1.merge(hash2)        
    end

end