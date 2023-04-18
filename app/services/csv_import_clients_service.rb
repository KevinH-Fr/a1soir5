class CsvImportClientsService
    require 'csv'
    def call(file)
        file = File.open(file)
        csv = CSV.parse(file, headers: true, col_sep: ';' )
    
        csv.each do |row|
          client_hash = {}
          client_hash[:nom] = row['NomClient'] 
          client_hash[:prenom] = row['PrenomClient'] 
          client_hash[:typepropart] = row['TypeClient'] 
          client_hash[:tel] = row['Tel1'] 
          client_hash[:tel2] = row['Tel2'] 
          client_hash[:mail] = row['Mail1'] 
          client_hash[:mail2] = row['Mail2'] 
          client_hash[:adresse] = row['AdressePostale'] 
          client_hash[:ville] = row['Ville'] 
          client_hash[:cp] = row['CP'] 
          client_hash[:pays] = row['Pays'] 
          client_hash[:commentaires] = row['Commentaires'] 
          Client.create(client_hash)
        end
    end

end