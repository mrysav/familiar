class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_admin!
    authenticate_user!
    unless current_user.editor?
      flash[:alert] = "You can't access this page!"
      redirect_to :back
    end
  end
end
