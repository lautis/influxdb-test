Rails.application.routes.draw do
  scope 'api/1' do
    resources :pings, only: [:create]
  end
end
