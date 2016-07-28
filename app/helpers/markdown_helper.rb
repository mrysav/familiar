module MarkdownHelper
    
    # Initializes a Markdown parser
    @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true), autolink: true, tables: true)
    
    def render_markdown(markdown, local_resources = false)
        #TODO
        if local_resources
            # Local photo embeds
            markdown.gsub!(/!\[([^\[\]]*)\] ?\[([0-9]+)(:[A-Za-z]+)?\]/) {
                if Photo.exists?($2.to_i)
                    image = Photo.find($2.to_i).image
                    url = image.thumb.url
                    url = image.url if $3 == ":full"
                    "![" + $1 + "](" + url + ")"
                end
            }
      
            # Link to person
            markdown.gsub!(/\[([^\[\]]+)\] ?\[@([0-9]+)\]/) {
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
