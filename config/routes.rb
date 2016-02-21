Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :destroys
  resources :users
	resources :beers
	resources :breweries
	resources :ratings

  resource :session, only: [:new, :create, :destroy]
  get 'places', to: 'places#index'
  post 'places', to:'places#search'
  resources :places, only:[:index, :show]
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
end
