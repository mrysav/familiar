class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  # Initializes a Markdown parser
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  
end