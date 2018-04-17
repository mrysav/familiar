class SessionsController < ApplicationController
    
    skip_before_action :verify_authenticity_token, only: :create
    
    def create
      auth = request.env["omniauth.auth"]
      user = User.authenticate(auth)
      session[:user_id] = user.id
      flash[:success] = "Signed in!"
      redirect_to root_url
    end

    def destroy
      session[:user_id] = nil
      flash[:success] = "Signed out!"
      redirect_to root_url
    end
    
    def new
    end
end
