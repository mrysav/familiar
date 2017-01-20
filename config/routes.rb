Rails.application.routes.draw do
    root 'search#index'
    
    get '/login' => 'sessions#new'
    get '/logout' => 'sessions#destroy', :as => :logout
    get '/register' => 'sessions#register', :as => :register
    match  "/auth/:provider/callback" => "sessions#create", via: [:get, :post]
    
    get '/search' => 'search#index'
    get '/tagged/:tag' => 'search#tagged', :as => :tagged
    
    get  '/import' => 'import#show'
    post '/import' => 'import#upload'
    get  '/import/jobs' => 'import#get_jobs_ajax', :as => :get_jobs

    get  '/export' => 'export#show'
    post '/export' => 'export#export', :as => :exports
    get  '/export/jobs' => 'export#jobs'
    
    get '/admin/users' => 'users#manage'
    get '/profile' => 'users#profile'
    
    resources :people
    resources :photos do
        resources :comments, :except => [:show, :edit]
    end
    resources :notes do
        resources :comments, :except => [:show, :edit]
    end
    
    namespace :api do
        resources :people, :only => [:show, :index]
    end
end
