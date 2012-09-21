App::Application.routes.draw do

     root :to => 'forums#index'

     get "log_out" => "sessions#destroy", :as => "log_out"
     get "log_in" => "sessions#new", :as => "log_in"
     get "sign_up" => "users#new", :as => "sign_up"
     post "profiles/change_pass"



     post  "topics/close"
     post  "topics/open"

     get "forums/search_posts"

     resources :users, :sessions, :admins
     resource :profile

     resources :forums, :except => :show do
       resources :topics do
         resources :posts
         member do
           post :move
         end
       end
     end

  scope controller: :admins do
    get "promote" => :promote
    get "demote"  => :demote
  end

end
