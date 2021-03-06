class ImportGrampsJob < ImportJobs
  queue_as :default

  def perform(*args)
      Rails.logger.info "Importing Gramps XML"
      
      # decompress if necessary
      gxml = decompress(args[0])
      
      # attempt to merge
      do_merge = !!args[1]
      
      begin
          doc = Nokogiri::XML(gxml, nil, "UTF-8") {|config| config.strict}
      rescue Exception => e
          Rails.logger.error "There was a problem importing document: " + e.message
          return
      end
      Rails.logger.debug "Removing namespaces from document (may take a minute)\n"
      doc.remove_namespaces!

      people = doc.xpath("//person")

      masterlist = []

      people.each do |person|
    
          p = {}
          # this is not the id you're looking for
          p['gid'] = person['id']
          p['first_name'] = person.xpath("name/first")[0].text
          p['last_name'] = person.xpath("name/surname")[0].text
          p['gender'] = person.xpath("gender").text

          person.xpath("eventref").each do |r|
              event = doc.xpath("//event[@handle='" + r['hlink'] + "']").first
              type = event.xpath("type").text
              if type == "Birth" || type == "Death" then
                  date = event.xpath("dateval").first || event.xpath("datestr").first
                  if date != nil && type == "Birth" then
                      p['date_of_birth'] = parse_date(date['val'])
                  elsif date!= nil && type == "Death" then
                      p['date_of_death'] = parse_date(date['val'])
                  end
                  
                  pevent = event.xpath("place").first
                  place_hlink = pevent["hlink"] if pevent
                  if(place_hlink)
                      place = doc.xpath("//placeobj[@handle='" + place_hlink + "']").first
                      pname = place.xpath("ptitle").text
                      p['birthplace'] = pname if type == "Birth"
                      p['burialplace'] = pname if type == "Death"
                  end
              end
          end
    
          masterlist.push(p)
      end      
      
      if(do_merge)
          Rails.logger.info 'Attempting to update people in database.'
          update_people(masterlist)
      else
          Rails.logger.info masterlist.count.to_s + " people. Performing first pass database insert (may take a minute)..."
          insert_people(masterlist)
      end

      Rails.logger.debug Person.count.to_s + " people in database after import."
      Rails.logger.info "Importing family relationships."

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
      
      Rails.logger.info "GrampsXML import complete."
  end
end
