Fluxqc::Application.routes.draw do
  devise_for :users

  resources :runs do
    member do
      post 'recall'
      post 'accept'
      post 'approve'
      post 'unapprove'
      post 'unpublish'
    end
  end


  resources :incubations 
  resources :fluxes

  root :to => 'runs#index'
end
