# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resource :session, only: :destroy
    resources :bulletins, only: %i[index new create show edit update] do
      member do
        patch :moderate
        patch :archive
      end
    end

    namespace :admin do
      root 'bulletins#moderate'

      resources :bulletins, only: :index do
        member do
          patch :archive
          patch :reject
          patch :publish
        end
      end
      resources :users, only: %i[index destroy]
      resources :categories, only: %i[index new create edit update destroy]
    end

    resource :profile, only: :show
  end
end
