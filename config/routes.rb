Rails.application.routes.draw do
  root to: 'static#index'
  devise_for :users

  resources :checklists
end
