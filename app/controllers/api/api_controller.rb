class Api::ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  
  helper_method :current_user
  helper_method :require_valid_user
  helper_method :authenticate_admin!
  
  def current_user
      token = request.headers["X-Auth-Token"]
      begin
          @current_user ||= User.find_by_access_token(token) if !token.empty?
      rescue
          @current_user = nil
      end
  end
  
  def require_valid_user
      if current_user == nil
          render :json => { :error => "Access denied" }, :status => 403
      end
  end
  
  def authenticate_admin!
      if current_user == nil || (current_user && !current_user.editor)
          render :json => { :error => "Insufficient permissions" }, :status => 403
      end
  end
end