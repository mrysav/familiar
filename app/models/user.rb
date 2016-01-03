class User < ActiveRecord::Base
    def self.create_with_omniauth(auth)
      create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.name = auth["info"]["name"]
        user.email = auth["info"]["email"]
        user.image = auth["info"]["image"]
        
        # Always make the first person to log in an editor
        user.editor = !User.exists?(1)
      end
    end
end
