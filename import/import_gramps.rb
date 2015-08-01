#!/usr/bin/env ruby

require 'nokogiri'
require 'chronic'

puts 'Important! Please make sure to strip the <?xml> and <!DOCTYPE> tags from your gramps XML file before trying to parse it here.'

puts "Opening data.gramps...\n"
f = File.open('import/data.gramps')
doc = Nokogiri::XML(f) {|config| config.strict}
f.close

puts "Removing namespaces from document...\n"
doc.remove_namespaces!

people = doc.xpath("//person")

masterlist = []

people.each do |person|
    
    p = {}
    # this is not the id you're looking for
    p['gid'] = person['id']
    p['name'] = person.xpath("name/first")[0].text + " " + person.xpath("name/surname")[0].text
    p['gender'] = person.xpath("gender").text

    person.xpath("eventref").each do |r|
        event = doc.xpath("//event[@handle='" + r['hlink'] + "']").first
        type = event.xpath("type").text
        if type == "Birth" || type == "Death" then
            date = event.xpath("dateval").first || event.xpath("datestr").first
            if date != nil && type == "Birth" then
                p['date_of_birth'] = Chronic.parse(date['val']).strftime("%Y-%m-%d")
            elsif date!= nil && type == "Death" then
                p['date_of_death'] = Chronic.parse(date['val']).strftime("%Y-%m-%d")
            end
        end
    end
    
    masterlist.push(p)
end

# yeah maybe comment this out someday
# just an idea
Person.all.each { |p| p.destroy }

puts masterlist.count.to_s + " people. Importing into database..."

masterlist.each do |data|
    p = Person.create(data.except('gid'))
    if(p.save) then
        data['id'] = p['id']
    else
        puts 'Error saving ' + data['name'] + '!'
    end
end

puts Person.count.to_s + " people in database."

families = doc.xpath("//family")

families.each do |family|
    f_link = family.xpath("father").first
    if f_link != nil then
        father = doc.xpath("//person[@handle='" + f_link['hlink'] + "']").first
    end
    m_link = family.xpath("mother").first
    if m_link != nil then
        mother = doc.xpath("//person[@handle='" + m_link['hlink'] + "']").first
    end

    if father != nil then 
        realFID = masterlist.detect{|p| p['gid'] == father['id']}['id']
    end
    if mother != nil then
        realMID = masterlist.detect{|p| p['gid'] == mother['id']}['id']
    end
    
    if realMID != nil && realFID != nil then
        f = Person.find(realFID)
        f.current_spouse_id = realMID
        m = Person.find(realMID)
        m.current_spouse_id = realFID
        f.save
        m.save
    end
    
    family.xpath("childref").each do |c|
        child = doc.xpath("//person[@handle='" + c['hlink'] + "']").first
        if child != nil
            realCID = masterlist.detect{|p| p['gid'] == child['id']}['id']
        end
        
        if realCID != nil && realFID != nil then
            p = Person.find(realCID)
            p.father_id = realFID
            p.save
        end
        
        if realCID != nil && realMID != nil then
            p = Person.find(realCID)
            p.mother_id = realMID
            p.save
        end
    end
end

puts "Family relationships imported."
    