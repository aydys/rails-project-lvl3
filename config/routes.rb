# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resource :session, only: %i[destroy]
    resources :bulletins, except: :destroy do
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
      resources :categories, except: :show
    end

    resource :profile, only: :show

    # namespace :profile do
    #   get '/', to: 'bulletins#index'
    # end
  end
end
