json.extract! fournisseur, :id, :nom, :pays, :telephone, :mail, :representant, :notes, :created_at, :updated_at
json.url fournisseur_url(fournisseur, format: :json)
