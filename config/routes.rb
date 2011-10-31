Fluxqc::Application.routes.draw do
  resources :incubations do
    resources :fluxes
  end

  root :to => 'incubations#index'
end
