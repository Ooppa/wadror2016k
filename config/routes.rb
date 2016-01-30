Rails.application.routes.draw do
	resources :beers

	resources :breweries
	resources :ratings
end
