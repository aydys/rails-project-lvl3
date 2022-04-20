Rails.application.routes.draw do
  scope module: 'web' do
    root 'bulletins#index'
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    resource :session, only: %i[destroy]

    resources :bulletins, only: %i[index new create show]
  end
end
