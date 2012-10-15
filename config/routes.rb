App::Application.routes.draw do

     post "profiles/change_pass"
     get "forums/search_posts"

     scope controller: :sessions do
       get "log_out" => :destroy, :as => "log_out"
       get "log_in" => :new, :as => "log_in"
     end




     resources :sessions, :admins

     resource :profile

     resources :users, :path_names => {:new => "sign_up"}  do
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
    get "promote"
    get "demote"
  end

  root :to => 'forums#index'

end
