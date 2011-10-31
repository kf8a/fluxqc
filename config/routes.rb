Fluxqc::Application.routes.draw do
  devise_for :users

  resources :incubations 
  resources :fluxes

  root :to => 'incubations#index'
end
