class SearchController < ApplicationController
    def index
        @results = PgSearch.multisearch(params[:s]).paginate(:page => params[:page], :per_page => 10)
    end
    
    def help
    end
    
    def tagged
        @results = Photo.tagged(params[:tag])
        @results = @results.paginate(:page => params[:p], :per_page => 10)
    end
end
