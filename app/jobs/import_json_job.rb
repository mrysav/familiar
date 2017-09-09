# frozen_string_literal: true

require 'fileutils'
require 'json'

##
# Performs an import from an exported JSON+Markdown+Picture archive.
class ImportJsonJob < ImportJobs
  queue_as :default

  def perform(*args)
    filename = File.basename(args[0], '.tar.gz')

    Rails.logger.info "Importing JSON archive #{filename}"

    # attempt to merge
    do_merge = args[1].to_s == 'true'

    import_path = '/tmp/import/'
    import_file = ImportUploader.new
    import_file.retrieve_from_store!(args[0])

    FileUtils.mkdir_p(import_path)
    Rails.logger.info `tar -xzvf #{import_file.file.file} -C #{import_path}`

    Dir.chdir(import_path + filename)

    file_to_local_person_id = {}
    file_to_local_note_id = {}
    file_to_local_photo_id = {}

    # TODO: Attempt merging
    if File.exist?('people.json')
      people = JSON.parse(File.read('people.json'))
      Rails.logger.info "Importing #{people.length} people"

      people.each do |person|
        p = Person.create(person.except('id'))
        if p.save
          file_to_local_person_id[person['id']] = p.id
        else
          Rails.logger.warn "Error saving person #{person['id']}:
                            #{person['first_name']} #{person['last_name']}"
        end
      end
    end

    if File.exist?('notes.json')
      notes = JSON.parse(File.read('notes.json'))
      Rails.logger.info "Importing #{notes.length} notes"

      notes.each do |note|
        n = Note.create(note.except('id', 'file_name'))
        n.content = File.read('notes/' + note['file_name'])
        if n.save
          file_to_local_note_id[note['id']] = n.id
        else
          Rails.logger.warn "Error saving note #{note['id']}: #{note['title']}"
        end
      end
    end

    if File.exist?('photos.json')
      photos = JSON.parse(File.read('photos.json'))
      Rails.logger.info "Importing #{photos.length} photos"

      photos.each do |photo|
        p = Photo.create(photo.except('id', 'file_name'))
        fname = photo['file_name'][photo['file_name'].index('_') + 1..-1]
        p.image.store_path(fname)
        if p.image.store!(File.open('photos/' + photo['file_name'])) && p.save
          file_to_local_photo_id[photo['id']] = p.id
        else
          Rails.logger.warn "Error saving photo #{photo['id']}: #{photo['title']}"
        end
      end
    end

    # TODO: Update resource IDs in Photo and Note descriptions

    Rails.logger.info 'Cleaning up...'
    FileUtils.rm_rf(import_path + filename)
    import_file.remove!
  end
end
