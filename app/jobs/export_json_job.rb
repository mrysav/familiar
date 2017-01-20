class ExportJsonJob < ActiveJob::Base
  require 'json'
  
  queue_as :default

  def perform(*args)
    export = args[0]
    archive_name = Time.now.to_i.to_s
    archive_name = export.tag + "_" + archive_name if !export.tag.blank?
    
    Rails.logger.info "Exporting JSON archive #{archive_name}"

    work_dir = '/tmp/' + archive_name

    Dir.mkdir(work_dir)
    Dir.chdir(work_dir)
    Dir.mkdir('notes')
    Dir.mkdir('photos')

    # Backup people
    File.open('people.json', 'w') do |file|
      file.write "[\n"

      Person.find_each do |person|
        p_json = person.to_json
        file.write "#{p_json}\n"
      end

      file.write "]"
    end

    # TODO: don't need this
    export.destroy

  end
end
