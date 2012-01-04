Fluxqc::Application.routes.draw do
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

  authenticated(:user) do
    mount Resque::Server, :at => "/resque"
  end
 
  root :to => 'runs#index'
end
