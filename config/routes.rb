Rails.application.routes.draw do
 

  resources :orders
  resources :products
  resources :order_items
  resources :orders do
  member do
    post :item_status
  end
  end
  resources :orders do
  collection do
    post :order_dispatched
  end
  end

  devise_for :users,
    controllers: {:registrations => "registrations"}

  devise_scope :user do
    authenticated :user do
      root 'orders#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
