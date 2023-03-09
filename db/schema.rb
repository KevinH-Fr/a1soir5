# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_09_171938) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "annonces", force: :cascade do |t|
    t.text "principale"
    t.text "soiree"
    t.text "mariee"
    t.text "homme"
    t.text "accessoire"
    t.text "deguisement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articleoptions", force: :cascade do |t|
    t.string "nature"
    t.text "description"
    t.decimal "prix"
    t.decimal "caution"
    t.string "taille"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "article_id"
    t.index ["article_id"], name: "index_articleoptions_on_article_id"
  end

  create_table "articles", force: :cascade do |t|
    t.integer "quantite"
    t.integer "commande_id"
    t.integer "produit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "prix"
    t.decimal "total"
    t.string "locvente"
    t.decimal "caution"
    t.boolean "longueduree"
    t.decimal "totalcaution"
    t.index ["commande_id"], name: "index_articles_on_commande_id"
    t.index ["produit_id"], name: "index_articles_on_produit_id"
  end

  create_table "avoirrembs", force: :cascade do |t|
    t.string "typeavoirremb"
    t.decimal "montant"
    t.string "natureavoirremb"
    t.integer "commande_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commande_id"], name: "index_avoirrembs_on_commande_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "nom"
    t.string "mail"
    t.text "commentaires"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tel"
    t.string "prenom"
    t.string "typepropart"
    t.string "intitule"
    t.string "tel2"
    t.string "mail2"
    t.string "adresse"
    t.string "ville"
    t.string "cp"
    t.string "pays"
    t.string "contact"
  end

  create_table "commandes", force: :cascade do |t|
    t.string "nom"
    t.decimal "montant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.date "debutloc"
    t.date "finloc"
    t.date "dateevenement"
    t.string "statutarticles"
    t.string "typeevenement"
    t.integer "profile_id"
    t.text "commentairesdoc"
    t.text "textefasimpledoc"
    t.boolean "location"
    t.index ["client_id"], name: "index_commandes_on_client_id"
    t.index ["profile_id"], name: "index_commandes_on_profile_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "ensembles", force: :cascade do |t|
    t.string "articleparent"
    t.string "categorieenfant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "categorieenfant2"
    t.string "categorieenfant3"
    t.string "categorieenfant4"
    t.string "categorieenfant5"
    t.string "categorieenfant6"
  end

  create_table "fournisseurs", force: :cascade do |t|
    t.string "nom"
    t.string "pays"
    t.string "telephone"
    t.string "mail"
    t.string "representant"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friends", force: :cascade do |t|
    t.string "name"
    t.string "mail"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labels", force: :cascade do |t|
    t.text "principale"
    t.text "soiree"
    t.text "mariee"
    t.text "homme"
    t.text "accessoire"
    t.text "deguisement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "info"
    t.text "boutique"
  end

  create_table "meetings", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commande_id"
    t.integer "client_id"
    t.string "lieu"
    t.index ["client_id"], name: "index_meetings_on_client_id"
    t.index ["commande_id"], name: "index_meetings_on_commande_id"
  end

  create_table "messagemails", force: :cascade do |t|
    t.string "titre"
    t.text "body"
    t.integer "commande_id"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mail"
    t.string "intitule"
    t.text "commentairedoc"
    t.text "commentairefasimple"
    t.string "typedoc"
    t.boolean "editpdf"
    t.boolean "editmail"
    t.boolean "editprint"
    t.index ["client_id"], name: "index_messagemails_on_client_id"
    t.index ["commande_id"], name: "index_messagemails_on_commande_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modelsousarticles", force: :cascade do |t|
    t.string "nature"
    t.text "description"
    t.decimal "prix"
    t.decimal "caution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paiements", force: :cascade do |t|
    t.string "typepaiement"
    t.decimal "montant"
    t.integer "commande_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nature"
    t.string "moyenpaiement"
    t.text "commentaire"
    t.index ["commande_id"], name: "index_paiements_on_commande_id"
  end

  create_table "postbis", force: :cascade do |t|
    t.text "body"
    t.string "access"
    t.string "passcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantite"
  end

  create_table "produits", force: :cascade do |t|
    t.string "nom"
    t.decimal "prix"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "categorie"
    t.boolean "vitrine"
    t.string "couleur"
    t.decimal "caution"
    t.string "handle"
    t.string "reffrs"
    t.string "taille"
    t.integer "quantite"
    t.boolean "eshop"
    t.string "nomfrs"
    t.datetime "dateachat"
    t.decimal "prixachat"
    t.string "typearticle"
    t.decimal "prixlocation"
    t.integer "fournisseur_id"
    t.index ["fournisseur_id"], name: "index_produits_on_fournisseur_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "prenom"
    t.string "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sousarticles", force: :cascade do |t|
    t.integer "article_id", null: false
    t.string "nature"
    t.text "description"
    t.decimal "prix_sousarticle"
    t.decimal "caution_sousarticle"
    t.string "taille"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "produit_id"
    t.index ["article_id"], name: "index_sousarticles_on_article_id"
    t.index ["produit_id"], name: "index_sousarticles_on_produit_id"
  end

  create_table "textes", force: :cascade do |t|
    t.string "titre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "adresse"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articleoptions", "articles"
  add_foreign_key "articles", "commandes"
  add_foreign_key "articles", "produits"
  add_foreign_key "avoirrembs", "commandes"
  add_foreign_key "commandes", "clients"
  add_foreign_key "commandes", "profiles"
  add_foreign_key "meetings", "clients"
  add_foreign_key "meetings", "commandes"
  add_foreign_key "messagemails", "clients"
  add_foreign_key "messagemails", "commandes"
  add_foreign_key "paiements", "commandes"
  add_foreign_key "produits", "fournisseurs"
  add_foreign_key "sousarticles", "articles"
  add_foreign_key "sousarticles", "produits"
end
