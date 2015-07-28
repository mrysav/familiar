class Comment < ActiveRecord::Base
  belongs_to :photo
  
  def cool_date
      return self.updated_at.strftime("%l:%M %p, %B %-d, %Y")
  end
end
