class ImportController < ApplicationController
    before_filter :require_editor
    
    def show
    end
    
    def upload
        ImportGrampsJob.perform_later(params[:file].read)
        redirect_to import_path
    end
    
end
