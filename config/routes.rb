Rails.application.routes.draw do
  resources :beers

  resources :breweries

  get 'ratings', to: 'ratings#index'

end
