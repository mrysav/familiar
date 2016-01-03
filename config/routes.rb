Rails.application.routes.draw do
    root 'search#index'
    
    get '/login', to: redirect('/auth/facebook')
    get '/logout' => 'sessions#destroy', :as => :logout
    get "/auth/:provider/callback" => "sessions#create"
    
    get '/search' => 'search#index'
    get '/tagged/:tag' => 'search#tagged'
    
    get '/help' => 'search#help'
    
    get  '/import' => 'import#show'
    post '/import' => 'import#upload'
    
    get '/admin/users' => 'users#manage'
    get '/profile' => 'users#profile'
    
    resources :people
    resources :photos do
        resources :comments, :except => [:show, :edit]
    end
    resources :notes do
        resources :comments, :except => [:show, :edit]
    end
end
