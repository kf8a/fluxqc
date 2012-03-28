Fluxqc::Application.routes.draw do
  resources :templates

  devise_for :users

  resources :runs do
    member do
      post 'reject'
      post 'accept'
      post 'approve'
      post 'publish'
      post 'unapprove'
      post 'unpublish'
    end
  end


  resources :incubations 
  resources :fluxes
  resources :setups

  authenticated(:user) do
    mount Resque::Server, :at => "/resque"
  end
 
  root :to => 'runs#index'
end
