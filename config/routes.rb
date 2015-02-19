Rails.application.routes.draw do
  root to: 'static#index'
  devise_for :users

  resources :checklists do
    resources :checklist_items, only: [:create, :update, :destroy]
  end
end
