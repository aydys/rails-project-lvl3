# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resource :session, only: %i[destroy]
    resources :bulletins, except: :destroy
    patch '/bulletins/:id/to_moderate', to: 'bulletins#to_moderate', as: 'moderate_bulletin'
    patch '/bulletins/:id/reject', to: 'bulletins#reject', as: 'reject_admin_bulletin'
    patch '/bulletins/:id/publish', to: 'bulletins#publish', as: 'publish_admin_bulletin'
    patch '/bulletins/:id/archive', to: 'bulletins#archive', as: 'archive_bulletin'
    patch 'admin/bulletins/:id/archive', to: 'admin/bulletins#archive', as: 'archive_admin_bulletin'

    namespace :admin do
      root 'bulletins#moderate'

      resources :bulletins, only: :index
      resources :users, only: %i[index destroy]
      resources :categories, except: %i[show]
    end

    namespace :profile do
      get '/', to: 'bulletins#index'
    end
  end
end
