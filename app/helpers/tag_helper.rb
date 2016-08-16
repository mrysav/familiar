module TagHelper
    def render_tags(tags)
        #TODO?
        rendered = []
        tags.each do |t|
            local_resource = resolve_tag(t)
            if local_resource
                rendered.push(link_to local_resource[:text], local_resource[:url])
            else
                rendered.push(link_to t, tagged_path(t))
            end
        end
        rendered.join(', ').html_safe
    end
    
    def resolve_tag(tag)
        t = tag.downcase
        val = {}
        
        # Legacy
        short_person_tag = /@([0-9]+)/.match(t)
        if short_person_tag
            pid = short_person_tag.captures[0].to_i;
            if Person.exists?(pid)
                person = Person.find(pid)
                val[:url] = url_for(person)
                val[:text] = person.name
                return val
            end
        end
        
        # New style
        image_tag = /i(?:mage)?:([0-9]+)/i.match(t)
        if image_tag
            id = image_tag.captures[0].to_i
            if Photo.exists?(id)
                photo = Photo.find(id)
                val[:text] = photo.title
                val[:url] = url_for(photo)
                return val
            end
        end
        
        person_tag = /p(?:erson)?:([0-9]+)/i.match(t)
        if person_tag
            id = person_tag.captures[0].to_i
            if Person.exists?(id)
                person = Person.find(id)
                val[:text] = person.name
                val[:url] = url_for(person)
                return val
            end
        end
        
        note_tag = /n(?:ote)?:([0-9]+)/i.match(t)
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
