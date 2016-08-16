module MarkdownHelper
    # necessary so we don't duplicate tag resolution
    include TagHelper
    
    # Initializes a Markdown parser
    @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true), autolink: true, tables: true)
    
    def render_markdown(markdown, local_resources = false)
        #TODO
        if local_resources
            # Local photo embeds
            markdown.gsub!(/!\[([^\[\]]*)\] ?\[([0-9]+)\]/) {
                if Photo.exists?($2.to_i)
                    image = Photo.find($2.to_i).image
                    url = image.thumb.url
                    url = image.url if $3 == ":full"
                    "![" + $1 + "](" + url + ")"
                end
            }
      
            # Link to resource
            markdown.gsub!(/\[([^\[\]]+)\] ?\[([A-z0-9@:]+)\]/) {
                tag = $2.to_s
                tag_text = $1.to_s
                resolved_tag = resolve_tag(tag)
                if resolved_tag[:url]
                    "[" + tag_text + "](" + resolved_tag[:url] + ")"
                else
                    tag_text
                end
            }
        end
      
        return @@markdown.render(markdown).html_safe
    end
end
