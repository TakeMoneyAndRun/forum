App::Application.routes.draw do

  devise_for :users, :skip => [:passwords]

  get "forums/search_posts"


  resources  :admins, :only => [:new, :create]

  resource :profile, :only => :show

  resources :users, :only => [:index, :show]  do
    resources :bookmarks, :only => [:create, :destroy]
    member do
      post "ban" => :ban
      post "unban" => :unban
      post "promote" => :promote
      post "demote"  => :demote
    end
  end

  resources :forums, :except => :show do
    resources :topics do
      resources :posts do
        member do
          post :vote
          post :complain
          post :hide
        end
      end
      member do
        post :move
        get :close
        get :open
      end
    end
  end

  root :to => 'forums#index'

end
