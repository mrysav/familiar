#!/usr/bin/env ruby

require 'nokogiri'

puts 'Important! Please make sure to strip the <?xml> and <!DOCTYPE> tags from your gramps XML file before trying to parse it here.'

puts "Opening data.gramps...\n"
f = File.open('data.gramps')
doc = Nokogiri::XML(f) {|config| config.strict}
f.close

puts "Removing namespaces from document...\n"
doc.remove_namespaces!

people = doc.xpath("//person")

people.each do |person|
    print person['id'] + ": "
    fullName = person.xpath("name/first")[0].text + " " + person.xpath("name/surname")[0].text
    print fullName
    gender = person.xpath("gender").text
    print " (" + gender + ") "

    person.xpath("eventref").each do |r|
        event = doc.xpath("//event[@handle='" + r['hlink'] + "']").first
        type = event.xpath("type").text
        if type == "Birth" || type == "Death" then
            date = event.xpath("dateval").first || event.xpath("datestr").first
            if date != nil then
                print " (" + date['val'] + ") " 
            end
        end
    end
    puts
end
