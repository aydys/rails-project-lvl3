Rails.application.routes.draw do
  scope module: 'web' do
    root 'home#index'
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resource :session, only: %i[destroy]
  end
end
