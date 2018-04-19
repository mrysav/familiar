# frozen_string_literal: true

##
# Manages importing data
class ImportController < ApplicationController
  before_action :authenticate_admin!

  def show; end

  def upload
    if params[:type] == 'gramps'
      ImportGrampsJob.perform_later(params[:file].read, params[:merge])
      flash[:info] = 'GRAMPS import job scheduled.'
    elsif params[:type] == 'gedcom'
      ImportGedcomJob.perform_later(params[:file].read, params[:merge])
      flash[:info] = 'GEDCOM import scheduled.'
    elsif params[:type] == 'json'
      uploaded_file = ImportUploader.new
      uploaded_file.store!(params[:file])
      ImportJsonJob.perform_later(uploaded_file.filename, params[:merge])
      flash[:info] = 'JSON import scheduled.'
    else
      flash[:warning] = 'Unable to import the given format.'
    end
    redirect_to import_path
  end

  def list_jobs_ajax; end
end
