Rails.application.routes.draw do
  resources :reservations, only: %i[create]
end
