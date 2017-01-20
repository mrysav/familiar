class ImportController < ApplicationController
    before_filter :require_editor
    
    def show
    end
    
    def upload
        if(params[:type] == "gramps") then
            ImportGrampsJob.perform_later(params[:file].read, params[:merge])
            flash[:info] = "GRAMPS import job scheduled."
        elsif(params[:type] == "gedcom") then
            ImportGedcomJob.perform_later(params[:file].read, params[:merge])
            flash[:info] = "GEDCOM import scheduled."
        else
            flash[:warning] = "Unable to import the given format."
        end
        redirect_to import_path
    end

    def get_jobs_ajax
    end
    
end
