Fluxqc::Application.routes.draw do
  get "runs/index"

  get "runs/show"

  devise_for :users

  resources :incubations 
  resources :fluxes

  root :to => 'incubations#index'
end
