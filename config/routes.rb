Rails.application.routes.draw do
  root :to => 'beers#index'

  resources :styles
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

  # Togglet
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :users do
    post 'froze_and_activate', on: :member
  end
  resources :beer_clubs do
    post 'toggle_confirmed', on: :member
  end

  # JS Toiminnallisuus
  get 'beerlist', to:'beers#list'
  get 'brewerylist', to:'breweries#nglist'
  get 'ngbeerlist', to:'beers#nglist'
end
