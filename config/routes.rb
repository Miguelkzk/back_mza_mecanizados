# config/routes.rb
Rails.application.routes.draw do
  # drive routes
  get 'drive/files', to: 'drive#index'
  get 'drive/files/:id/view', to: 'drive#show'
  post 'drive/folders', to: 'drive#create_folder'
  delete 'drive/folders/:id', to: 'drive#destroy'
  post 'drive/upload', to: 'drive#upload'

  resources :clients
  resources :orders
end
