class ExportController < ApplicationController
    before_filter :require_editor

    def show
    end
    
    def export

        begin
            export = Export.create!(export_params)
            export.status = :pending
            export.save!

            if(export.format == "json") then
                ExportJsonJob.perform_later(export)
                flash[:info] = "JSON export job scheduled."
            end
        rescue Exception => e
            flash[:warning] = "Unable to schedule export: " + e.to_s
        end
        redirect_to exports_path
    end

    def jobs
        exports = []
        Export.find_each do |e|
            exports.push({:tag => e.tag, 
                          :date => e.created_at.to_i,
                          :link => ""})
        end
        render :json => exports
    end

    private
    
    def export_params
        params.require(:export).permit(:tag, :format)
    end
end
