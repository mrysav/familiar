require 'stringio'

class ImportGedcomJob < ImportJobs
  queue_as :default

  def perform(*args)
      Rails.logger.info "Importing GEDCOM (assuming v5.5/Lineage-Linked)"

      doc = Gedcom.read(StringIO.new(args[0]))
      people = doc.transmissions[0].individual_record

      masterlist = []

      people.each do |person|
          p = {}
          # this is the "INDI" id in the GEDCOM file -- it will not actually be saved
          p['gid'] = person.id[0].xref_value if person.id && !person.id.empty?
          p['name'] = person.primary_name.tr('/','')
          p['gender'] = person.sex[0].value[0] if person.sex && !person.sex.empty?

          bday = person.birth[0].date if person.birth && !person.birth.empty?
          dday = person.death[0].date if person.death && !person.death.empty?
          p['date_of_birth'] = parse_date(bday) if bday
          p['date_of_death'] = parse_date(dday) if dday
    
          masterlist.push(p)
      end

      Rails.logger.info masterlist.count.to_s + " people. Performing first pass database insert (may take a minute)..."

      masterlist.each do |data|
          p = Person.create(data.except('gid'))
          if(p.save) then
              data['id'] = p['id']
          else
              Rails.logger.warn 'Error saving ' + data['name'] + '!'
          end
      end

      Rails.logger.debug Person.count.to_s + " people in database after import."
      Rails.logger.info "Importing family relationships."

      families = doc.transmissions[0].family_record

      (families || []).each do |family|
          #TODO: Fix this ugly hack, probably in gedcom code
          father = family.husband if family.husband_ref.first
          mother = family.wife if family.wife_ref.first

          if father != nil then
              realFID = masterlist.detect{|p| p['gid'] == father.id[0].xref_value}['id']
          end
          if mother != nil then
              realMID = masterlist.detect{|p| p['gid'] == mother.id[0].xref_value}['id']
          end

          if realMID != nil && realFID != nil then
              f = Person.find(realFID)
              f.current_spouse_id = realMID
              m = Person.find(realMID)
              m.current_spouse_id = realFID
              f.save
              m.save
          end

          (family.children || []).each do |child|
              realCID = masterlist.detect{|p| p['gid'] == child.xref_value}['id']

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

      Rails.logger.info "GEDCOM import complete."
  end
end
