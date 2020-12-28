# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'site#index'

  get '/signin', action: :new, controller: 'sessions', as: :sign_in
  delete '/signout', action: :destroy, controller: 'sessions', as: :sign_out
  get '/auth/github/callback', action: :create, controller: 'sessions'

  patch '/users', to: 'users#update', as: :user

  get '/settings', action: :index, controller: 'settings'

  get '/privacy', to: 'site#privacy'
end
