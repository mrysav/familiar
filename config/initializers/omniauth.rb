Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets.facebook_id, Rails.application.secrets.facebook_secret, 
      :image_size => { :width => 200, :height => 200 },
      :secure_image_url => :true
      
  provider :google_oauth2, Rails.application.secrets.google_id, Rails.application.secrets.google_secret
  
  provider :identity, :fields => [:name, :email, :image], on_failed_registration: lambda { |env|    
    SessionsController.action(:register).call(env)
  }
end