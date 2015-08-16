Rails.application.routes.draw do
  scope 'api/1' do
    resources :pings, only: [:create] do
      member do
        get 'hours'
      end
    end
  end

  root to: 'dashboard#index'
end
