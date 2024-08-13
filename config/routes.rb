# config/routes.rb
Rails.application.routes.draw do
  get 'drive/files', to: 'drive#index'
end
