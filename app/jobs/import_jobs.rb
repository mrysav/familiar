class ImportJobs < ActiveJob::Base
    
    # These are helpers for import jobs
    
    # Attempts to detect compression and returns an uncompressed object
    def decompress(payload)
        begin
            ActiveSupport::Gzip.decompress(payload)
        rescue Zlib::GzipFile::Error
            Rails.logger.info "No GZIP compression detected. Continuing."
            payload
        end
    end
    
    # Attempts to parse a date with great flexbility and 
    # the possibility of abysmal accuracy
    # may return nil
    def parse_date(raw_date)
        
        # don't even try
        if raw_date.blank?
            return nil
        end
        
        # first try EDTF parsing
        date = Date.edtf(raw_date)
        
        # if EDTF parse fails, use Chronic instead
        if date == nil
            # Rails.logger.info "EDTF date parsing unsuccessful for \"" + raw_date + "\", attempting Chronic parsing (possibly less accurate)"
            # TODO: Add more to this for more accuracy?
            date = Chronic.parse(raw_date).strftime("%Y-%m-%d")
        end
        
        return date
    end
end