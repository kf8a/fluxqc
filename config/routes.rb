Fluxqc::Application.routes.draw do
  scope 'tracegas' do
    devise_for :users

    resources :runs

    resources :incubations 
    resources :fluxes

    root :to => 'incubations#index'
  end
end
