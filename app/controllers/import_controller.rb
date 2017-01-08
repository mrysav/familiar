class ImportController < ApplicationController
    before_filter :require_editor
    
    def show
    end
    
    def upload
        #TODO: make this behave the same way
        if(params[:type] == "gramps") then
            ImportGrampsJob.perform_later(params[:file].read, params[:merge])
        elsif(params[:type] == "gedcom") then
            ImportGedcomJob.perform_later(params[:file].read, params[:merge])
        end
        redirect_to import_path
    end
    
end
