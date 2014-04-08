Fluxqc::Application.routes.draw do

  get "measurements/show"
  resources :templates

  devise_for :users

  resources :runs do
    member do
      get  'gcinput'
      get  'standard_curves'
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
  resources :standard_curves, only: [:show, :update]
  resources :setups
  resources :samples

  resources :measurements, only: :index

  # authenticated(:user) do
  #   mount Resque::Server, :at => "/resque"
  # end
 
  get "runs/:id/standards" => 'runs#show'
  root :to => 'runs#index'
end
