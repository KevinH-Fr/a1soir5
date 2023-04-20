class CsvImportProduitsService
  require 'csv'
  require 'open-uri'

  def call(file)
    file = File.open(file)
    csv = CSV.parse(file, headers: true, col_sep: ',' )

    csv.each do |row|
      produit_hash = {}
      produit_hash[:nom] = row["Product Name"]
      produit_hash[:prix] = row["Variant Price"].delete('€').to_i
      produit_hash[:caution] = row["Variant Price"].delete('€').to_i
      produit_hash[:description] = row["Product Description"] 
      produit_hash[:categorie] = row["Product Categories"]
      produit_hash[:taille] = row["Option1 Value"]
      produit_hash[:quantite] = row["Variant Inventory"]

      # Attach main image to the record
      main_image_url = URI.parse(row['Main Variant Image'])
      main_image_filename = File.basename(main_image_url.path)
      main_image = main_image_url.open
      produit = Produit.new(produit_hash)
      produit.image1.attach(io: main_image, filename: main_image_filename, content_type: ['image/png', 'image/jpeg'])

      # Attach additional image to the record
      if row['More Variant Images'].present?
        additional_image_urls = row['More Variant Images'].split(',').map(&:strip)
        additional_image_urls.each_with_index do |additional_image_url, index|
          additional_image_filename = "additional_image_#{index}.jpg" # You can use any name for the additional images
          additional_image = URI.parse(additional_image_url).open
          produit.images.attach(io: additional_image, filename: additional_image_filename, content_type: ['image/png', 'image/jpeg'])
        end
      end

      produit.save
    end
  end
end

         
  # voir avec cha les correspondances possibles à ajouter : 
  # produit_hash[:dateachat] = row[1] 
  # produit_hash[:prixachat] = row[1] 
  # produit_hash[:prixlocation] = row[1] 
  # produit_hash[:couleur] = row[1] 
  # produit_hash[:handle] = row[1] 
  # produit_hash[:reffrs] = row[1] 
