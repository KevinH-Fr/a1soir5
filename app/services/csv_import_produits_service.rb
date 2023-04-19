class CsvImportProduitsService
    require 'csv'
    def call(file)
        file = File.open(file)
        csv = CSV.parse(file, headers: true, col_sep: ',' )
    
        csv.each do |row|
          produit_hash = {}
          produit_hash[:nom] = row[1] 
          Produit.create(produit_hash)
        end
    end

end