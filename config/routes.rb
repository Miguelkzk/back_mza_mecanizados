# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # drive routes
  get 'drive/files', to: 'drive#index'
  get 'drive/files/:id/view', to: 'drive#show'
  post 'drive/folders', to: 'drive#create_folder'
  delete 'drive/folders/:id', to: 'drive#destroy'
  post 'drive/upload', to: 'drive#upload'

  resources :clients do
  end

  resources :drawings do
    collection do
      post :upload
    end
  end

  resources :orders do
    collection do
      get :filter_by_state
      post :production_sheet
    end
    member do
      post :generate_work_order
      get :materials_in_order
    end
  end

  resources :suppliers do
    collection do
      get :index_with_note
    end
    member do
      get :show_notes
    end
  end
  resources :materials

  resources :certificate_of_materials do
    collection do
      post :upload
    end
  end

  resources :supplier_delivery_notes do
    collection do
      post :upload
    end
  end

  resources :delivery_notes do
    collection do
      post :upload
    end
  end

  resources :file_purchase_orders do
    collection do
      post :upload
    end
  end

  resources :remunerations do
    collection do
      get :show_parents
      post :create_remuneration_for_month
    end
    member do
      get :show_childrens
    end
  end

  resources :machines do
    member do
      post :generate_routine_sheet
      post :generate_corrective_sheet
      post :generate_preventive_sheet
      get :show_maintenances
    end
  end

  resources :maintenances do
    collection do
      post :upload
    end
  end

  resources :events do
  end

  resources :assessments do
  end

  # rutas para usuarios
  post 'signup', to: 'users#create'
  post 'login', to: 'auth#login'
  get 'auto_login', to: 'auth#auto_login'
  post 'login', to: 'auth#login'
end
