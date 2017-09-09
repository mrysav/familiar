class ExportController < ApplicationController
    before_action :require_editor

    def show
        @exports = Export.all.order(created_at: :desc)
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
                          :link => e.archive.url,
                          :status => e.status })
        end
        render :json => exports
    end

    private
    
    def export_params
        params.require(:export).permit(:tag, :format)
    end
end
