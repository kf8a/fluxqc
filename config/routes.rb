Fluxqc::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get "measurements/show"
  resources :templates

  devise_for :users

  resources :runs do
    member do
      get  'gcinput'
      get  'standard_curves'
      get  'updated_at'
      post 'reject'
      post 'accept'
      post 'approve'
      post 'publish'
      post 'unapprove'
      post 'unpublish'
      post 'unreject'
      post 'park'
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
