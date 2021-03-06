Rails.application.routes.draw do
  root to: 'static#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :checklists do
    resources :checklist_items, only: [:create, :update, :destroy]
  end

  resources :github_repositories, only: :show

  post '/github/webhook', to: 'webhooks#github', as: :github_webhook

  constraints ->(request) { request.env['warden'].authenticate? && request.env['warden'].user.admin? } do
    match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
  end
end
