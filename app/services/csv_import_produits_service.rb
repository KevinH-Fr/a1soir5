class CsvImportProduitsService
    require 'csv'
    def call(file)
        file = File.open(file)
        csv = CSV.parse(file, headers: true, col_sep: ',' )
    
        csv.each do |row|
          produit_hash = {}
          produit_hash[:nom] = row["Product Name"] 
          produit_hash[:prix] = row["Variant Price"] 
          produit_hash[:caution] = row["Variant Price"] # =prix vente à recupérer un integer ou decimal : enlever la ref euro
          produit_hash[:description] = row["Product Description"] 
          produit_hash[:categorie] = row["Product Categories"] #verif pas d'erreur de validation sur enum 
          produit_hash[:taille] = row["Option1 Value"] #verif pas d'erreur validation
          produit_hash[:quantite] = row["Variant Inventory"] # correspond au stock restant ? 
         
         # voir avec cha les correspondances possibles à ajouter : 
          # produit_hash[:dateachat] = row[1] 
          # produit_hash[:prixachat] = row[1] 
          # produit_hash[:prixlocation] = row[1] 
          # produit_hash[:couleur] = row[1] 
          # produit_hash[:handle] = row[1] 
          # produit_hash[:reffrs] = row[1] 

          Produit.create(produit_hash)
        end
    end

end