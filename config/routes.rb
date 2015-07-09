Rails.application.routes.draw do
    root 'search#index'
    
    get '/login', to: redirect('/auth/facebook')
    get '/logout' => 'sessions#destroy', :as => :logout
    get "/auth/:provider/callback" => "sessions#create"
    
    get '/search' => 'search#index'
    
    resources :people do
        resources :relationships
    end
end
