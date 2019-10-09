Rails.application.routes.draw do

  root "tournaments#index"

  resources :tournaments do
    resources :results, only: [:index, :create]
  end
  resources :teams, except: [:new, :create, :destroy]

end
