module TagHelper
    def render_tags(tags)
        #TODO?
        rendered = []
        tags.each do |t|
            person_tag = /@([1-9]+)/.match(t)
            if person_tag
                pid = person_tag.captures[0].to_i;
                if Person.exists?(pid)
                    person = Person.find(pid)
                    url = url_for(person)
                    rendered.push(link_to person.name, tagged_path(t))
                else
                    rendered.push(link_to t, tagged_path(t))
                end
            else
                rendered.push(link_to t, tagged_path(t))
            end
        end
        rendered.join(', ').html_safe
    end
end
