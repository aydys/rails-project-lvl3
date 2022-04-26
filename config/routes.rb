Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resource :session, only: %i[destroy]
    resources :bulletins, except: :destroy
    patch '/bulletins/:id/to_moderate', to: 'bulletins#to_moderate', as: 'bulletin_moderate'
    patch '/bulletins/:id/archive', to: 'bulletins#archive', as: 'bulletin_archive'
    patch '/bulletins/:id/publish', to: 'bulletins#publish', as: 'bulletin_publish'

    namespace :admin do
      root 'bulletins#moderate'

      resources :bulletins, only: :index
      resources :users, only: %i[index destroy]
      resources :categories, except: %i[show]
    end

    namespace :profile do
      root 'bulletins#index'
    end
  end
end
