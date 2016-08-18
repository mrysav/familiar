module TagHelper
    include RegexConstants
    
    def render_tags(tags, render_resource_tags = false)
        rendered = []
        tags.each do |t|
            if render_resource_tags
                local_resource = resolve_tag(t)
                if local_resource
                    rendered.push(link_to local_resource[:text], local_resource[:url])
                else
                    rendered.push(link_to t, tagged_path(t))
                end
            else
                rendered.push(link_to t, tagged_path(t))
            end
        end
        rendered.join(', ').html_safe
    end
    
    def resolve_tag(tag)
        t = tag.downcase
        val = {}
        
        # New style
        image_tag = REGEX_IMAGE_TAG.match(t)
        if image_tag
            id = image_tag.captures[0].to_i
            if Photo.exists?(id)
                photo = Photo.find(id)
                val[:text] = photo.title
                val[:url] = url_for(photo)
                return val
            end
        end
        
        person_tag = REGEX_PERSON_TAG.match(t)
        if person_tag
            id = person_tag.captures[0].to_i
            if Person.exists?(id)
                person = Person.find(id)
                val[:text] = person.full_name
                val[:url] = url_for(person)
                return val
            end
        end
        
        note_tag = REGEX_NOTE_TAG.match(t)
        if note_tag
            id = note_tag.captures[0].to_i
            if Note.exists?(id)
                note = Note.find(id)
                val[:text] = note.title
                val[:url] = url_for(note)
                return val
            end
        end
    end
end
