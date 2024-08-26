# config/routes.rb
Rails.application.routes.draw do
  # drive routes
  get 'drive/files', to: 'drive#index'
  get 'drive/files/:id/view', to: 'drive#show'
  post 'drive/folders', to: 'drive#create_folder'
  delete 'drive/folders/:id', to: 'drive#destroy'
  post 'drive/upload', to: 'drive#upload'

  resources :clients do
    collection do
      get :find_by_name
      get :filter_by_name_and_status
    end
  end

  resources :orders do
    collection do
      get 'filter_by_state'
    end
  end
end
