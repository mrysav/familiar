class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  
  def cool_date
      return self.updated_at.strftime("%l:%M %p, %B %-d, %Y")
  end
  
  def render_markdown
      #TODO
      return @@markdown.render(self.body).html_safe
  end
end
