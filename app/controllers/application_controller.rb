class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user
  helper_method :require_valid_user
  helper_method :require_editor
  
  def current_user
      begin
          @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue
          @current_user = nil
      end
  end
  
  def require_valid_user
      if session[:user_id] == nil || current_user == nil
          respond_to do |format|
              flash[:warning] = "Must be logged in to do that."
              format.html { redirect_to root_path }
          end
      end
  end
  
  def require_editor
      if (session[:user_id] == nil || current_user == nil) || (current_user && !current_user.editor)
          respond_to do |format|
              flash[:warning] = "Insufficient permissions."
              format.html { redirect_to root_path }
          end
      end
  end
end
