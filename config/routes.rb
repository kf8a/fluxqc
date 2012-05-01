Fluxqc::Application.routes.draw do

  resources :templates

  devise_for :users

  resources :runs do
    member do
      get 'standards'
      get  'gcinput'
      post 'reject'
      post 'accept'
      post 'approve'
      post 'publish'
      post 'unapprove'
      post 'unpublish'
      post 'unreject'
    end
  end


  resources :incubations 
  resources :fluxes
  resources :standard_curves
  resources :setups
  resources :samples

  authenticated(:user) do
    mount Resque::Server, :at => "/resque"
  end
 
  root :to => 'runs#index'
end
