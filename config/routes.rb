Rails.application.routes.draw do

  resources :postbis

  # partie publique

  root 'accueil#index' 
   
  get 'home', to: 'home#index'

  get 'contact', to: 'accueil#contact'
  get 'infos', to: 'accueil#infos'
  get 'boutique', to: 'accueil#boutique'
 
  get 'robes_soirees', to: 'accueil#soirees'
  get 'robes_mariees', to: 'accueil#mariees'
  get 'costumes_hommes', to: 'accueil#costumes'
  get 'accessoires', to: 'accueil#accessoires'
  get 'costumes_deguisements', to: 'accueil#deguisements'
   
  get 'plan', to: 'accueil#plan'
   
  # partie admin
  get 'accueil_admin', to: 'accueil_admin#index'
  get 'search', to: 'search#index'
  get 'marketing', to: 'accueil_admin#marketing'
  get 'analyses', to: 'accueil_admin#analyses'
  get 'listeSelection', to: 'accueil_admin#listeSelection'
  get 'stock', to: 'accueil_admin#stock'

  get 'selection_produit', to: 'selection_produit#index'
  get 'scanqr', to: 'selection_produit#scanqr'


  devise_for :users
   
  resources :users do
    member do
      #get :toggle_status
      get :toggle_status_user
      get :toggle_status_vendeur
      get :toggle_status_admin
      get :editer_mail
    end
  end

  resources :clients do
    member do
      get :send_client_mail, 
          to: 'clients#send_client_mail', 
          as: :send_client_mail
      post :edit
      get :nouveau_client
    end
  end

  resources :fournisseurs do
    member do
      post :edit
      #get :nouveau_fournisseur
    end
  end

  resources :produits do
    member do
      post :edit
      get :dupliquer
    end
  end

 # resources :etiquettes
  get "/etiquettes", to: "etiquettes#index", as: :index
  get "/etiquettes/edition", to: "etiquettes#edition", as: :edition_etiquettes
  #tempo test etiquette
  #get 'etiquette', to: 'etiquettes#edition'


  resources :ensembles do
    member do 
      post :edit
    end
  end

  resources :commandes do

    member do
      get :toggle_commande_client
      get :toggle_statut_retire
      get :toggle_statut_non_retire
      get :toggle_statut_rendu

      get :toggle_edition
      get :toggle_editer

      get :generate_pdf, format: 'pdf'
      get :editer_pdf

      get :send_commande_mail, 
          to: 'commandes#send_commande_mail', 
          as: :send_commande_mail
      
      
      get :send_messagemail_mail_commande, 
          to: 'messagemails#send_messagemail_commande', 
          as: :send_messagemail_mail_commande


      post :edit
    end
  end

  resources :meetings do
    member do
      get :toggle_rendezvous_client
      post :edit
      get :editer_mail
      get :rappel_rdv
      post :invite

    end
  end 

  get 'calendar/week' => 'calendar#week', as: :calendar_week
  get 'calendar/month' => 'calendar#month', as: :calendar_month



  resources :profiles do
    member do
      post :edit
    end
  end 

  resources :ensembles do
    member do 
      post :edit
    end
  end

  resources :messagemails do
    member do 

      get :send_messagemail_commande, 
      to: 'messagemails#send_messagemail_commande', 
      as: :send_messagemail_commande

      get :editer_pdf
      get :editer_print
      get :editer_mail
     # post :edit
      
    end
  end

  resources :posts # pour tests

  resources :paiements do
    member do 
      post :edit
    end
  end

  resources :avoirrembs do
    member do 
      post :edit
    end
  end
  
  resources :articles do
    member do
      get :toggle_selectProduit
      get :toggle_transformer_ensemble
      post :edit
    end 
  end

  resources :sousarticles do
    member do
      get :toggle_sousarticleauto
      post :edit
    end
  end 
  
  resources :labels do
    member do
      post :edit
    end
  end 

  resources :textes do
    member do
      post :edit
    end
  end 

end
