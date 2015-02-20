Rails.application.routes.draw do
  root to: 'static#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :checklists do
    resources :checklist_items, only: [:create, :update, :destroy]
  end
end
