# config/routes.rb
Rails.application.routes.draw do
  get 'drive/files', to: 'drive#index'
  get 'drive/files/:id/view', to: 'drive#show'
  post 'drive/folders', to: 'drive#create_folder'
end
