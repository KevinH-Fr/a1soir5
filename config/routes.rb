Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

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


   resources :clients do
    member do
      get :send_client_mail, 
          to: 'clients#send_client_mail', 
          as: :send_client_mail
      post :edit
      get :nouveau_client
    end
  end

  resources :produits do
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
  
end
