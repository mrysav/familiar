class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user
  helper_method :require_valid_user
  helper_method :require_editor
  helper_method :render_markdown
  
  # Initializes a Markdown parser
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true), autolink: true, tables: true)
  
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
  
  def render_markdown(markdown, local_resources = false)
      
      #TODO
      
      if local_resources
          # Local photo embeds
          markdown.gsub!(/!\[(.*)\] ?\[([1-9]+)(:[A-z]+)?\]/) {
              if Photo.exists?($2.to_i)
                  image = Photo.find($2.to_i).image
                  url = image.thumb.url
                  url = image.url if $3 == ":full"
                  "![" + $1 + "](" + url + ")"
              end
          }
      
          # Link to person
          markdown.gsub!(/\[(.*)\] ?\[@([1-9]+)\]/) {
              if Person.exists?($2.to_i)
                  person = Person.find($2.to_i)
                  url = url_for(person)
                  "[" + $1 + "](" + url + ")"
              else
                  $1
              end
          }
      end
      
      return @@markdown.render(markdown).html_safe
  end
end
