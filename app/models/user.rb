class User < ApplicationRecord
    before_create :generate_access_token
    
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
      
    def self.authenticate(auth)
        user = find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
        
        # always update the image url if necessary
        if user.name != auth["info"]["image"]
            user.image = auth["info"]["image"]
            user.save!
        end
        
        if user.access_token.blank?
            user.generate_access_token
            user.save!
        end
        
        return user
    end
      
    def generate_access_token
        begin
            self.access_token = SecureRandom.hex
        end while self.class.exists?(access_token: access_token)
    end
end
