class SearchController < ApplicationController
    def index
        @results = PgSearch.multisearch(params[:s]).paginate(:page => params[:page], :per_page => 12)
    end
    
    def help
    end
    
    def tagged
        @results = Photo.tagged_with(params[:tag]) + Note.tagged_with(params[:tag])
        @results = @results.sort_by { |obj| obj.updated_at }.reverse!
        @results = @results.paginate(:page => params[:p], :per_page => 15)
    end
end
