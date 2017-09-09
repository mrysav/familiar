# frozen_string_literal: true

require 'json'

##
# Exports all data to a json+photo+markdown archive
class ExportJsonJob < ExportJobs
  
  queue_as :default

  def perform(*args)
    export = args[0]
    archive_name = Time.now.to_i.to_s
    archive_name = (export.tag.blank? ? 'familiar' : export.tag) + "_" + archive_name
    archive_file_name = sanitize_filename(archive_name)

    Rails.logger.info "Exporting JSON archive #{archive_file_name}"

    work_dir = '/tmp/' + archive_file_name

    Dir.mkdir(work_dir)
    Dir.chdir(work_dir)
    Dir.mkdir('notes')
    Dir.mkdir('photos')

    # Backup people
    File.open('people.json', 'w') do |file|
      file.write "[\n"

      is_first = true
      Person.find_each do |person|
        p_json = person.to_json
        if is_first
          is_first = false
        else
          file.write ",\n"
        end
        file.write p_json.to_s
      end

      file.write "\n]"
    end

    # Backup notes
    File.open('notes.json', 'w') do |file|
      file.write "[\n"

      is_first = true
      Note.find_each do |note|
        n_fname = note.title + '.md'
        sanitize_filename(n_fname)
        n_json = { title: note.title, date: note.date, id: note.id,
                   created_at: note.created_at, updated_at: note.updated_at, 
                   tag_list: note.tag_list, 
                   file_name: n_fname }.to_json
        if is_first
          is_first = false
        else
          file.write ",\n"
        end
        file.write n_json.to_s
        File.open('notes/' + n_fname, 'w') do |md|
          md.write note.content
        end
      end

      file.write "\n]"
    end

    # Backup photos
    File.open('photos.json', 'w') do |file|
      file.write "[\n"

      is_first = true
      Photo.find_each do |photo|
        p_fname = photo.id.to_s + "_" + photo.image.file.filename
        p_json = { title: photo.title, date: photo.date, description: photo.description,
                   created_at: photo.created_at, updated_at: photo.updated_at, 
                   tag_list: photo.tag_list, id: photo.id,
                   file_name: p_fname }.to_json
        if is_first
          is_first = false
        else
          file.write ",\n"
        end
        file.write p_json.to_s
        File.open('photos/' + p_fname, 'wb') do |p|
          p.write photo.image.read
        end
      end

      file.write "\n]"
    end

    Dir.chdir('/tmp')

    dest_filename = '/tmp/' + archive_file_name + '.tar.gz'
    system("tar -czf #{ dest_filename } #{ archive_file_name }")

    export.archive.store!(Pathname.new(dest_filename).open)
    Rails.logger.info "Uploaded #{ dest_filename } successfully."
    export.status = :complete
    
    if export.save
      Rails.logger.info "Saved export #{export.id} successfully."
    else
      Rails.logger.warn "Unable to save export #{export.id}."
    end

  end
end
