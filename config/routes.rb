# config/routes.rb
Rails.application.routes.draw do
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
    end
    member do
      post :generate_work_order
      get :materials_in_order
    end
  end

  resources :suppliers
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
end
