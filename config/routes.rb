App::Application.routes.draw do

     get "log_out" => "sessions#destroy", :as => "log_out"
     get "log_in" => "sessions#new", :as => "log_in"
     get "sign_up" => "users#new", :as => "sign_up"
     post "profiles/change_pass"



      get "forums/search_posts"

     resources :sessions, :admins
     resource :profile


     resources :users do
       resources :bookmarks, :only => [:create, :destroy]
       member do
         post "ban" => :ban
         post "unban" => :unban
       end
     end

     resources :forums, :except => :show do
       resources :topics do
         resources :posts
         member do
           post :move
           post :close
           post :open
         end
       end
     end

  scope controller: :admins do
    get "promote" => :promote
    get "demote"  => :demote
  end

  root :to => 'forums#index'

end
