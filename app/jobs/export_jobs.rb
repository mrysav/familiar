class ExportJobs < ActiveJob::Base

    def sanitize_filename(filename)
        filename.strip!
        # NOTE: File.basename doesn't work right with Windows paths on Unix
        # get only the filename, not the whole path
        filename.gsub!(/^.*(\\|\/)/, '')

        # Strip out the non-ascii character
        filename.gsub!(/[^0-9A-Za-z.\-]/, '_')
    end

end