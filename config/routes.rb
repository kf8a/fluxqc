Fluxqc::Application.routes.draw do
  resources :incubations 
  resources :fluxes

  root :to => 'incubations#index'
end
